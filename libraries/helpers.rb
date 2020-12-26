module Vault
  module Cookbook
    module Helpers
      def default_vault_user
        'vault'
      end

      def default_vault_group
        'vault'
      end

      def default_vault_packages
        %w(vault)
      end
    end
  end
end
