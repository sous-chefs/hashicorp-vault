#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'
require 'uri'

module VaultCookbook
  module Resource
    # A `vault_service` resource for managing Vault as a system
    # service.
    # @action enable
    # @action disable
    # @action start
    # @action stop
    # @action restart
    # @since 1.0
    class VaultService < Chef::Resource
      include Poise
      provides(:vault_service)
      include PoiseService::ServiceMixin

      # @!attribute config_path
      # @return [String]
      attribute(:config_path, kind_of: String, default: '/etc/vault/vault.json')

      # @!attribute directory
      # @return [String]
      attribute(:directory, kind_of: String, default: '/var/run/vault')

      # @!attribute user
      # @return [String]
      attribute(:user, kind_of: String, default: 'vault')

      # @!attribute group
      # @return [String]
      attribute(:group, kind_of: String, default: 'vault')

      # @!attribute environment
      # @return [String]
      attribute(:environment, kind_of: Hash, default: { PATH: '/usr/local/bin:/usr/bin:/bin' })

      # @!attribute disable_mlock
      # @return [String]
      attribute(:disable_mlock, kind_of: [TrueClass, FalseClass], default: false)

      # @!attribute vault_binary
      # @return [String]
      attribute(:vault_binary, kind_of: String, default: '/usr/local/bin/vault')
    end
  end

  module Provider
    # A `vault_service` provider for managing Vault as a system
    # service.
    # @provides vault_service
    # @since 1.0
    class Chef::Provider::VaultService < Chef::Provider
      include Poise
      provides(:vault_service)
      include PoiseService::ServiceMixin

      def action_enable
        notifying_block do
          directory new_resource.directory do
            owner new_resource.owner
            group new_resource.group
          end

          package 'libcap2-bin' do
            only_if { platform?('ubuntu') && node['platform_version'].split('.')[0] == '12' }
          end

          execute "setcap cap_ipc_lock=+ep #{new_resource.vault_binary}" do
            not_if { platform_family?('windows', 'mac_os_x') }
            not_if { new_resource.disable_mlock }
            not_if "getcap #{new_resource.vault_binary}|grep cap_ipc_lock+ep"
          end
        end
        super
      end

      def service_options(service)
        service.command("#{new_resource.vault_binary} -config=#{new_resource.config_path}")
        service.directory(new_resource.directory)
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
