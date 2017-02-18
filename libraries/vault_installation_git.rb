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
    # @example
    #   vault_installation '0.5.0' do
    #     provider 'git'
    #   end
    # @since 2.0
    class VaultInstallationGit < Chef::Provider
      include Poise(inversion: :vault_installation)
      provides(:git)
      inversion_attribute('hashicorp-vault')

      # Set the default inversion options.
      # @return [Hash]
      # @api private
      def self.default_inversion_options(node, new_resource)
        # Checkout inside $GOPATH to ensure discovery works for included
        # packages (e.g., `vault/cli`)
        super.merge(
          version: new_resource.version,
          git_url: 'https://github.com/hashicorp/vault',
          git_path: "#{node['go']['gopath']}/src/github.com/hashicorp/vault"
        )
      end

      def action_create
        notifying_block do
          # Require Go 1.6.1 as Vault depends on new functionality in net/http
          node.default['go']['version'] = '1.6.1'
          include_recipe 'golang::default', 'build-essential::default'
          # Install required go packages for building Vault
          golang_package 'github.com/mitchellh/gox'
          golang_package 'github.com/tools/godep'
          golang_package 'golang.org/x/tools/cmd/cover'
          golang_package 'github.com/golang/go/src/cmd/vet'

          # Ensure paths exist for checkout, or git will fail
          directory options[:git_path] do
            action :create
            recursive true
          end

          git options[:git_path] do
            repository options[:git_url]
            reference options.fetch(:git_ref, "v#{new_resource.version}")
            action :checkout
          end

          # Use godep to restore dependencies before attempting to compile
          if new_resource.version < '0.6.0'
            execute('godep restore') do
              cwd options[:git_path]
              environment(PATH: "#{node['go']['install_dir']}/go/bin:#{node['go']['gobin']}:/usr/bin:/bin",
                          GOPATH: node['go']['gopath'])
            end
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

      def vault_program
        ::File.join(options[:git_path], 'bin', 'vault')
      end
    end
  end
end
