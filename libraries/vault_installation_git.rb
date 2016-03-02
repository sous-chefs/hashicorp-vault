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
    # A `vault_installation` provider which manages Vault installation
    # from the Go source builds.
    # @action create
    # @action remove
    # @provides vault_installation
    # @since 2.0
    class VaultInstallationGit < Chef::Provider
      include Poise(inversion: :vault_installation)
      provides(:binary)

      # Set the default inversion options.
      # @return [Hash]
      # @api private
      def self.default_inversion_options(node, new_resource)
        super.merge(
          version: new_resource.version,
          git_url: 'https://github.com/hashicorp/vault',
          git_ref: 'master',
          git_path: '/usr/local/src/vault'
        )
      end

      def action_create
        notifying_block do
          include_recipe 'golang::default', 'build-essential::default'

          git options[:git_path] do
            repository options[:git_url]
            reference options[:git_ref]
            action :checkout
          end

          golang_package 'github.com/mitchellh/gox' do
            action :install
          end

          golang_package 'github.com/tools/godep' do
            action :install
          end
        end
      end

      def action_remove
        notifying_block do
          directory options[:git_path] do
            recursive true
            action :delete
          end
        end
      end

      def vault_binary
        ::File.join(options[:git_path], 'bin', 'vault')
      end
    end
  end
end
