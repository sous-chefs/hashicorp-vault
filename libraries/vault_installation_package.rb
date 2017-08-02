#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module VaultCookbook
  module Provider
    # A `vault_installation` provider which installs Vault from
    # package source.
    # @action create
    # @action remove
    # @provides vault_installation
    # @example
    #   vault_installation '0.5.0' do
    #     provider 'package'
    #   end
    # @since 2.0
    class VaultInstallationPackage < Chef::Provider
      include Poise(inversion: :vault_installation)
      provides(:package)
      inversion_attribute('hashicorp-vault')

      # The built-in resource "package" has it's own attribute named "options",
      # so we should use an alias to access Poise inversion options.
      alias res_options options

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
          package res_options[:package_name] do
            source res_options[:package_source]
            provider res_options[:package_provider]
            version res_options[:version]
            action :upgrade
          end
        end
      end

      def action_remove
        notifying_block do
          package res_options[:package_name] do
            source res_options[:package_source]
            provider res_options[:package_provider]
            version res_options[:version]
            action :remove
          end
        end
      end

      def vault_program
        options.fetch(:vault_program, '/usr/local/bin/vault')
      end
    end
  end
end
