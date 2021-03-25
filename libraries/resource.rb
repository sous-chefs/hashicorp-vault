require 'hcl/checker'

module Vault
  module Cookbook
    module ResourceHelpers
      def vault_hcl_config_resource_init
        vault_hcl_config_resource_create unless vault_hcl_config_resource_exist?
      end

      def vault_hcl_config_resource
        return unless vault_hcl_config_resource_exist?

        find_resource!(:template, new_resource.config_file)
      end

      def vault_hcl_resource_data
        {
          name: new_resource.type,
          description: new_resource.description,
          options: new_resource.options,
        }
      end

      def vault_hcl_config_current_load(config_file)
        return {} unless vault_hcl_config_current_valid?(config_file)

        hclconf = HCL::Checker.parse(File.read(config_file))
        hclconf[:global] = hclconf.filter { |_, v| !v.is_a?(Hash) }
        hclconf.transform_keys!(&:to_sym)
        hclconf.filter! { |_, v| v.is_a?(Hash) }

        hclconf
      end

      private

      def vault_hcl_config_resource_exist?
        !find_resource!(:template, new_resource.config_file).nil?
      rescue Chef::Exceptions::ResourceNotFound
        false
      end

      def vault_hcl_config_resource_create
        with_run_context(:root) do
          edit_resource(:directory, ::File.dirname(new_resource.config_file)) do
            owner new_resource.owner
            group new_resource.group
            mode '0750'

            recursive true

            action :create
          end

          edit_resource(:template, new_resource.config_file) do
            cookbook new_resource.cookbook
            source new_resource.template

            owner new_resource.owner
            group new_resource.group
            mode new_resource.mode
            sensitive new_resource.sensitive

            helpers(Vault::Cookbook::TemplateHelpers)

            action :nothing
            delayed_action :create
          end
        end
      end

      def vault_hcl_config_current_valid?(config_file)
        HCL::Checker.valid?(File.read(config_file))
      rescue Errno::ENOENT
        false
      end
    end
  end
end
