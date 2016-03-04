#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

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
      provides(:git)

      # Set the default inversion options.
      # @return [Hash]
      # @api private
      def self.default_inversion_options(node, new_resource)
        super.merge(
          version: new_resource.version,
          git_url: 'https://github.com/hashicorp/vault',
          git_path: '/usr/local/src/vault'
        )
      end

      def action_create
        notifying_block do
          include_recipe 'golang::default', 'build-essential::default'
          golang_package 'github.com/mitchellh/gox'
          golang_package 'github.com/tools/godep'

          git options[:git_path] do
            repository options[:git_url]
            reference options.fetch(:git_ref, "v#{new_resource.version}")
            action :checkout
          end

          execute 'make dev' do
            cwd options[:git_path]
            environment(PATH: "#{node['go']['install_dir']}/go/bin:#{node['go']['gobin']}:/usr/bin:/bin",
                        GOPATH: node['go']['gopath'])
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
