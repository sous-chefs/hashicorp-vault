#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'
require_relative 'helpers_installation_binary'

module VaultCookbook
  module Provider
    # A `vault_installation` provider which manages Vault binary
    # installation from remote source URL.
    # @action create
    # @action remove
    # @provides vault_installation
    # @since 2.0
    class VaultInstallationBinary < Chef::Resource
      include Poise(inversion: :vault_installation)
      include Helpers::InstallationBinary
      provides(:binary)

      # Set the default inversion options.
      # @return [Hash]
      # @api private
      def self.default_inversion_options(node, new_resource)
        super.merge({
          version: new_resource.version,
          archive_url: "https://releases.hashicorp.com/vault/%{version}/#{binary_filename}",
          archive_checksum: default_binary_checksum,
          extract_to: '/opt/vault'
        })
      end

      def action_install
        basename = binary_filename
        notifying_block do
          include_recipe 'libarchive::default'

          archive = remote_file basename do
            path ::File.join(Chef::Config[:file_cache_path], basename)
            source options[:archive_url]
            checksum options[:archive_checksum]
          end

          directory ::File.join(options[:extract_to], new_resource.version) do
            recursive true
          end

          libarchive_file basename do
            path archive.path
            mode options[:extract_mode]
            owner options[:extract_owner]
            group options[:extract_group]
            extract_to ::File.join(options[:extract_to], new_resource.version)
            extract_options options[:extract_options]
          end
        end
      end

      def action_uninstall
        notifying_block do
          directory ::File.join(options[:extract_to], new_resource.version) do
            recursive true
            action :delete
          end
        end
      end

      def vault_binary
        ::File.join(options[:extract_to], new_resource.version, 'vault')
      end
    end
  end
end
