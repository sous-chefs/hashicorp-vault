#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'
require_relative 'vault_installation'

module VaultCookbook
  module Provider
    # A `vault_installation` provider which installs Vault from
    # package source.
    # @action create
    # @action remove
    # @provides vault_installation
    # @since 2.0
    class VaultInstallationPackage < Chef::Provider
      include Poise(inversion: :vault_installation)
      provides(:package)

      # Set the default inversion options.
      # @return [Hash]
      # @api private
      def self.default_inversion_options(node, new_resource)
        super.merge(
          version: new_resource.version,
          package_name: 'vault'
        )
      end

      def action_create
        notifying_block do
          package options[:package_name] do
            source options[:package_source]
            checksum options[:package_checksum]
            version options[:version]
            action :upgrade
          end
        end
      end

      def action_remove
        notifying_block do
          package options[:package_name] do
            source options[:package_source]
            checksum options[:package_checksum]
            version options[:version]
            action :uninstall
          end
        end
      end

      def vault_binary
        options.fetch(:vault_binary, '/usr/local/bin/vault')
      end
    end
  end
end
