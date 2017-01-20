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
      # The Vault configuration file path.
      # @return [String]
      attribute(:config_path, kind_of: String, default: '/etc/vault/vault.json')
      # @!attribute directory
      # The directory to start the Vault process.
      # @return [String]
      attribute(:directory, kind_of: String, default: '/var/run/vault')
      # @!attribute user
      # The service user that Vault process should run as.
      # @return [String]
      attribute(:user, kind_of: String, default: 'vault')
      # @!attribute group
      # The service group the Vault process should run as.
      # @return [String]
      attribute(:group, kind_of: String, default: 'vault')
      # @!attribute environment
      # The environment the Vault process should run with.
      # @return [String]
      attribute(:environment, kind_of: Hash, default: { PATH: '/usr/local/bin:/usr/bin:/bin' })
      # @!attribute disable_mlock
      # @see https://www.vaultproject.io/docs/config/index.html#disable_mlock
      # @return [String]
      attribute(:disable_mlock, kind_of: [TrueClass, FalseClass], default: false)
      # @!attribute program
      # The location of the Vault executable.
      # @return [String]
      attribute(:program, kind_of: String, default: '/usr/local/bin/vault')
      # @!attribute log_level
      # The log-level of the service
      # @return [String]
      attribute(:log_level, default: 'info', equal_to: %w(trace debug info warn err))
    end
  end

  module Provider
    # A `vault_service` provider for managing Vault as a system
    # service.
    # @provides vault_service
    # @since 1.0
    class VaultService < Chef::Provider
      include Poise
      provides(:vault_service)
      include PoiseService::ServiceMixin

      def action_enable
        notifying_block do
          directory new_resource.directory do
            owner new_resource.user
            group new_resource.group
          end

          package 'libcap2-bin' do
            only_if { node.platform_family?('debian') }
          end

          execute "setcap cap_ipc_lock=+ep #{new_resource.program}" do
            not_if { platform_family?('windows', 'mac_os_x', 'freebsd') }
            not_if { platform_family?('rhel') && node['platform_version'].to_i < 6 }
            not_if { new_resource.disable_mlock }
            not_if "getcap #{new_resource.program}|grep cap_ipc_lock+ep"
          end
        end
        super
      end

      def service_options(service)
        service.command("#{new_resource.program} server -config=#{new_resource.config_path} -log-level=#{new_resource.log_level}")
        service.directory(new_resource.directory)
        service.user(new_resource.user)
        service.environment(new_resource.environment)
        service.restart_on_update(false)
        service.options(:sysvinit, template: 'hashicorp-vault:sysvinit.service.erb')
        service.options(:systemd, template: 'hashicorp-vault:systemd.service.erb')

        if platform_family?('rhel') && node['platform_version'].to_i == 6
          service.provider(:sysvinit)
        end
      end
    end
  end
end
