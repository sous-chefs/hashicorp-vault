module Vault
  module Cookbook
    module TemplateHelpers
      def nil_or_empty?(v)
        v.nil? || (v.respond_to?(:empty?) && v.empty?)
      end

      def vault_hcl_value(value)
        case value
        when TrueClass, FalseClass, Array
          value.to_s
        when String
          "\"#{value}\""
        when Integer
          value
        else
          raise ArgumentError, "vault_hcl_value: Unsupported variable type #{value.class}. Value: #{value}."
        end
      end

      def vault_hcl_configuration_items
        %i(@auto_auth @cache @entropy @listener @seal @sentinel @service_registration @storage @telemetry @template @vault)
      end

      VAULT_HCL_CONFIG_CONTAINED ||= %w(auto_auth).freeze

      def template_render_hcl(type, items)
        hcl = []

        case items
        when Array
          if VAULT_HCL_CONFIG_CONTAINED.include?(type)
            hcl.push(render('vault/_hcl_items_contained.erb', cookbook: 'hashicorp-vault', variables: { container: type, items: items }))
          else
            items.each do |conf_item|
              conf_item_type = conf_item.fetch(:type, type)
              hcl.push(
                render(
                  'vault/_hcl_item.erb',
                  cookbook: 'hashicorp-vault',
                  variables: { type: conf_item_type, name: conf_item[:name], description: conf_item[:description], properties: conf_item[:options] }
                )
              )
            end
          end
        when Hash
          hcl.push(render('vault/_hcl_item.erb', cookbook: 'hashicorp-vault', variables: { type: type, properties: items }))
        end

        hcl.join("\n")
      end

      private

      def template_partial_indent(output, level, spaces = 2)
        raise ArgumentError unless spaces > 0

        output.split("\n").each { |l| l.prepend(' ' * (level * spaces)) }.join("\n")
      end
    end
  end
end
