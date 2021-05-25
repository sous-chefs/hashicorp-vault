module Vault
  module Cookbook
    module TemplateHelpers
      include Vault::Cookbook::CommonHelpers

      VAULT_HCL_CONFIG_CONTAINED = %i(auto_auth).freeze
      VAULT_HCL_CONFIGURATION_ITEMS = %i(@global @auto_auth @cache @entropy @listener @seal @sentinel @service_registration @storage @telemetry @template @vault).freeze
      VAULT_HCL_CONFIG_BLOCK = %w(autopilot retry_join replication telemetry).freeze

      def vault_hcl_key(key)
        VAULT_HCL_CONFIG_BLOCK.include?(key) ? key : "#{key} ="
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

      def template_render_hcl(type, items)
        hcl = []

        case items
        when Array
          if VAULT_HCL_CONFIG_CONTAINED.include?(type.to_sym)
            hcl.push(render('vault/_hcl_items_contained.erb', cookbook: 'hashicorp-vault', variables: { container: type, items: items }))
          else
            items.each do |conf_item|
              hcl.push(
                render(
                  'vault/_hcl_item.erb',
                  cookbook: 'hashicorp-vault',
                  variables: { type: conf_item[:item_type], name: conf_item[:name], description: conf_item[:description], properties: conf_item[:options] }
                )
              )
            end
          end
        when Hash
          if type.eql?('global')
            hcl.push(render('vault/_hcl_settings.erb', cookbook: 'hashicorp-vault', variables: { properties: items }))
          else
            hcl.push(render('vault/_hcl_item.erb', cookbook: 'hashicorp-vault', variables: { type: type, properties: items }))
          end
        else
          raise ArgumentError, "Expected Array or Hash, got #{items.class}"
        end

        hcl.join("\n")
      end

      private

      def template_partial_indent(output, level, spaces = 2)
        raise ArgumentError, 'Spaces must be greater than 0' unless spaces > 0

        output.split("\n").each { |l| l.prepend(' ' * (level * spaces)) }.join("\n")
      end
    end
  end
end
