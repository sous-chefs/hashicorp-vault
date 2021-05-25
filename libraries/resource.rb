module Vault
  module Cookbook
    module ResourceHelpers
      include Vault::Cookbook::CommonHelpers

      VAULT_GLOBAL_PROPERTIES = %i(global cache sentinel telemetry vault).freeze

      def vault_hcl_file_prefix
        "config_#{vault_hcl_config_type}"
      end

      def vault_hcl_config_type
        rn = defined?(new_resource) ? new_resource.resource_name : resource_name
        rn.to_s.gsub('hashicorp_vault_config_', '').to_sym
      end

      def vault_hcl_resource_template_add(type = vault_hcl_config_type, value = vault_hcl_resource_data)
        with_run_context(:root) do
          edit_resource(:file, '/etc/vault.d/vault.hcl').action(:delete) if new_resource.vault_mode.eql?(:server) && ::File.exist?('/etc/vault.d/vault.hcl')
          edit_resource(:directory, new_resource.config_dir) do |new_resource|
            owner new_resource.owner
            group new_resource.group
            mode '0750'

            recursive true

            action :create
          end

          edit_resource(:template, new_resource.config_file) do |new_resource|
            cookbook new_resource.cookbook
            source new_resource.template

            owner new_resource.owner
            group new_resource.group
            mode new_resource.mode
            sensitive new_resource.sensitive

            helpers(Vault::Cookbook::TemplateHelpers)

            if VAULT_GLOBAL_PROPERTIES.include?(type)
              variables[type] = value
            else
              variables[type] ||= []
              variables[type].push(value) unless variables[type].include?(value)
            end

            case new_resource.vault_mode
            when :server
              action :create
            when :agent
              action :nothing
              delayed_action :create
            else
              raise "vault_hcl_resource_template: Invalid vault_mode #{new_resource.vault_mode}"
            end
          end
        end
      end

      def vault_hcl_resource_template_remove(type = vault_hcl_config_type, value = vault_hcl_resource_data)
        edit_resource(:template, new_resource.config_file).variables[type].delete(value)
      end

      def vault_hcl_resource_template?(type = vault_hcl_config_type, value = vault_hcl_resource_data)
        edit_resource(:template, new_resource.config_file).variables[type].include?(value)
      end

      def vault_hcl_config_current_load(config_file, config_type = nil)
        return {} unless vault_hcl_config_current_valid?(config_file)

        hclconf = HCL::Checker.parse(File.read(config_file)).transform_keys!(&:to_sym)
        hclconf[:global] = hclconf.filter { |_, v| !v.is_a?(Hash) && !v.is_a?(Array) }
        hclconf.filter! { |_, v| v.is_a?(Hash) || v.is_a?(Array) }
        hclconf = compact_hash(hclconf)

        return hclconf.fetch(config_type, {}) if config_type
        hclconf
      end

      private

      def vault_hcl_config_current_valid?(config_file)
        HCL::Checker.valid?(File.read(config_file))
      rescue Errno::ENOENT
        false
      end

      def vault_hcl_resource_data
        case vault_hcl_config_type
        when :auto_auth
          resource_data = {
            name: new_resource.type,
            options: new_resource.options,
            type: new_resource.entry_type,
          }

          if new_resource.entry_type.eql?(:sink)
            resource_data[:options]['config'] ||= {}
            resource_data[:options]['config']['path'] = new_resource.path
          end

          resource_data
        when :template
          {
            description: new_resource.description,
            item_type: vault_hcl_config_type,
            options: new_resource.options.merge('destination' => new_resource.destination),
          }
        else
          {
            description: new_resource.description,
            item_type: vault_hcl_config_type,
            options: new_resource.options,
            name: new_resource.type,
          }
        end
      end
    end
  end
end
