#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'
require_relative 'vault_installation_binary'
require_relative 'vault_installation_git'
require_relative 'vault_installation_package'

module VaultCookbook
  module Resource
    # A `vault_installation` resource for managing the installation of
    # Vault.
    # @action create
    # @action remove
    # @since 2.0
    class VaultInstallation < Chef::Resource
      include Poise(inversion: true)
      provides(:vault_installation)
      actions(:create, :remove)
      default_action(:create)

      # @!attribute version
      # The version of Vault to install.
      # @return [String]
      attribute(:version, kind_of: String, name_attribute: true)

      def vault_program
        @program ||= provider_for_action(:vault_program).vault_program
      end
    end
  end
end
