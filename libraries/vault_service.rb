#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'
require 'uri'

module VaultCookbook
  module Resource
    # Resource for managing the Vault service on an instance.
    # @since 1.0.0
    class VaultService < Chef::Resource
      include Poise
      provides(:vault_service)
      include PoiseService::ServiceMixin

      # @!attribute version
      # @return [String]
      attribute(:version, kind_of: String, required: true)

      # @!attribute install_method
      # @return [Symbol]
      attribute(:install_method, default: 'binary', equal_to: %w{source binary})

      # @!attribute install_path
      # @return [String]
      attribute(:install_path, kind_of: String, default: '/srv')

      # @!attribute config_path
      # @return [String]
      attribute(:config_path, kind_of: String, default: '/home/vault/.vault.json')

      # @!attribute user
      # @return [String]
      attribute(:user, kind_of: String, default: 'vault')

      # @!attribute group
      # @return [String]
      attribute(:group, kind_of: String, default: 'vault')

      # @!attribute environment
      # @return [String]
      attribute(:environment, kind_of: Hash, default: { PATH: '/usr/local/bin:/usr/bin:/bin' })

      # @!attribute binary_url
      # @return [String]
      attribute(:binary_url, kind_of: String)

      # @!attribute source_url
      # @return [String]
      attribute(:source_url, kind_of: String, default: 'https://github.com/hashicorp/vault')

      # @!attribute disable_mlock
      # @return [String]
      attribute(:disable_mlock, kind_of: [TrueClass, FalseClass], default: false)

      def source_dir
        uri = URI.parse(source_url)
        ::File.join(node['go']['gopath'], 'src', uri.host, uri.path)
      end

      def source_path
        ::File.join(source_dir, 'bin', 'vault')
      end

      # Returns the location of vault binary after installation without any symlinks
      def binary_path
        case install_method
        when 'binary'
          ::File.join(install_path, 'vault', 'current', 'vault')
        when 'source'
          source_path
        end
      end

      def bin_path
        '/usr/local/bin/vault'
      end

      def command
        "#{bin_path} server -config=#{config_path}"
      end

      def binary_checksum
        node['vault']['checksums'].fetch(binary_filename)
      end

      def binary_filename
        arch = node['kernel']['machine'] =~ /x86_64/ ? 'amd64' : '386'
        [version, node['os'], arch].join('_')
      end
    end
  end

  module Provider
    # Provider for managing the Vault service on an instance.
    # @since 1.0.0
    class Chef::Provider::VaultService < Chef::Provider
      include Poise
      provides(:vault_service)
      include PoiseService::ServiceMixin

      def action_enable
        notifying_block do
          if new_resource.install_method == 'binary'
            libartifact_file "vault-#{new_resource.version}" do
              artifact_name 'vault'
              artifact_version new_resource.version
              install_path new_resource.install_path
              remote_url new_resource.binary_url % { version: new_resource.version, filename: new_resource.binary_filename }
              remote_checksum new_resource.binary_checksum
            end
          else
            include_recipe 'golang::default'

            # gox is used to compile vault source code
            golang_package 'github.com/mitchellh/gox' do
              action :install
            end

            golang_package 'github.com/tools/godep' do
              action :install
            end

            include_recipe 'build-essential::default'

            # See https://www.vaultproject.io/docs/install/index.html
            directory new_resource.source_dir do
              recursive true
            end

            git new_resource.source_dir do
              repository new_resource.source_url
              reference "v#{new_resource.version}"
              action :checkout
            end

            custom_path = [::File.join(node['go']['install_dir'], 'go', 'bin'),
                           node['go']['gobin']].join(':')
            execute 'make dev' do
              cwd new_resource.source_dir
              # rubocop:disable Lint/ParenthesesAsGroupedExpression
              environment ({ PATH: "#{custom_path}:#{ENV['PATH']}",
                             GOPATH: node['go']['gopath'].to_s })
              # rubocop:enable Lint/ParenthesesAsGroupedExpression
            end
          end

          link new_resource.bin_path do
            to new_resource.binary_path
          end

          # setcap is not installed on ubuntu 12 by default
          package 'libcap2-bin' do
            only_if { platform?('ubuntu') && node['platform_version'].split('.')[0] == '12' }
          end

          # set capabilities before we start service
          execute "setcap cap_ipc_lock=+ep #{new_resource.binary_path}" do
            not_if { platform_family?('windows', 'mac_os_x') }
            not_if { new_resource.disable_mlock }
            not_if "getcap #{new_resource.binary_path}|grep cap_ipc_lock+ep"
          end
        end
        super
      end

      def service_options(service)
        service.command(new_resource.command)
        service.directory(::File.dirname(new_resource.config_path))
        service.user(new_resource.user)
        service.environment(new_resource.environment)
        service.restart_on_update(true)

        if node.platform_family?('rhel') && node.platform_version.to_i == 6
          service.provider(:sysvinit)
        end
      end
    end
  end
end
