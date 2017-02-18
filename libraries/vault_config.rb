#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module VaultCookbook
  module Resource
    # A `vault_config` resource for managing Vault's configuration
    # files.
    # @action create
    # @provides vault_config
    # @since 1.0
    class VaultConfig < Chef::Resource
      include Poise(fused: true)
      provides(:vault_config)

      # @!attribute path
      # The Vault configuration file path.
      # @return [String]
      attribute(:path, kind_of: String, name_attribute: true)
      # @!attribute owner
      # The Vault configuration file owner.
      # @return [String]
      attribute(:owner, kind_of: String, default: 'vault')
      # @!attribute group
      # The Vault configuration file group.
      # @return [String]
      attribute(:group, kind_of: String, default: 'vault')

      # @see https://vaultproject.io/docs/config/index.html
      attribute(:address, kind_of: String)
      attribute(:cluster_address, kind_of: String)
      attribute(:tls_disable, equal_to: [true, false, 1, 0, 'yes', 'no'], default: true)
      attribute(:tls_cert_file, kind_of: String)
      attribute(:tls_key_file, kind_of: String)
      attribute(:cache_size, kind_of: Integer)
      attribute(:disable_cache, equal_to: [true, false])
      attribute(:disable_mlock, equal_to: [true, false], default: false)
      attribute(:default_lease_ttl, kind_of: String)
      attribute(:max_lease_ttl, kind_of: String)
      attribute(:statsite_addr, kind_of: String)
      attribute(:statsd_addr, kind_of: String)
      attribute(:backend_type, default: 'inmem', equal_to: %w(consul etcd zookeeper dynamodb s3 mysql postgresql inmem file))
      attribute(:backend_options, option_collector: true)
      attribute(:habackend_type, kind_of: String)
      attribute(:habackend_options, option_collector: true)
      attribute(:telemetry_options, option_collector: true, default: {})

      def tls?
        if tls_disable == true || tls_disable == 'yes' || tls_disable == 1
          false
        else
          true
        end
      end

      # Transforms the resource into a JSON format which matches the
      # Vault service's configuration format.
      # @see https://vaultproject.io/docs/config/index.html
      def to_json
        # top-level
        config_keeps = %i(cache_size disable_cache disable_mlock default_lease_ttl max_lease_ttl)
        config = to_hash.keep_if do |k, _|
          config_keeps.include?(k.to_sym)
        end
        # listener
        listener_keeps = tls? ? %i(address cluster_address tls_cert_file tls_key_file) : %i(address cluster_address)
        listener_options = to_hash.keep_if do |k, _|
          listener_keeps.include?(k.to_sym)
        end.merge(tls_disable: tls_disable.to_s)
        config['listener'] = { 'tcp' => listener_options }
        # backend
        config['backend'] = { backend_type => (backend_options || {}) }
        # ha_backend, only some backends support HA
        if %w(consul etcd zookeeper dynamodb).include? habackend_type
          config['ha_backend'] = { habackend_type => (habackend_options || {}) }
        end
        config['telemetry'] = telemetry_options unless telemetry_options.empty?

        JSON.pretty_generate(config, quirks_mode: true)
      end

      action(:create) do
        notifying_block do
          directory ::File.dirname(new_resource.path) do
            recursive true
          end

          file new_resource.path do
            content new_resource.to_json
            owner new_resource.owner
            group new_resource.group
            mode '0640'
          end
        end
      end

      action(:remove) do
        notifying_block do
          file new_resource.path do
            action :delete
          end
        end
      end
    end
  end
end
