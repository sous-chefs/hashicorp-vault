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
    # @example
    #   vault_installation '0.5.0'
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

      def vault_binary
        @vault_binary ||= provider_for_action(:vault_binary).vault_binary
      end
    end
  end
end

Chef::Platform::ProviderPriorityMap.instance.priority(:vault_installation, [
  VaultCookbook::Provider::VaultInstallationBinary,
  VaultCookbook::Provider::VaultInstallationGit,
  VaultCookbook::Provider::VaultInstallationPackage
])
