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
      # TCP Listener options
      attribute(:address, kind_of: String)
      attribute(:cluster_address, kind_of: String)
      attribute(:proxy_protocol_behavior, equal_to: %i(use_always allow_authorized deny_unauthorized))
      attribute(:proxy_protocol_authorized_addrs, kind_of: String)
      attribute(:tls_disable, equal_to: [true, false, 1, 0, 'yes', 'no'], default: true)
      attribute(:tls_cert_file, kind_of: String)
      attribute(:tls_key_file, kind_of: String)
      attribute(:tls_min_version, kind_of: String)
      attribute(:tls_cipher_suites, kind_of: String)
      attribute(:tls_prefer_server_cipher_suites, kind_of: String)
      attribute(:tls_require_and_verify_client_cert, kind_of: String)
      attribute(:tls_disable_client_certs, kind_of: String)
      attribute(:tls_client_ca_file, kind_of: String)
      # Global options
      attribute(:cluster_name, kind_of: String)
      attribute(:cache_size, kind_of: Integer)
      attribute(:disable_cache, equal_to: [true, false])
      attribute(:disable_mlock, equal_to: [true, false], default: false)
      attribute(:default_lease_ttl, kind_of: String)
      attribute(:log_level, default: 'info', equal_to: %w(trace debug info warn err))
      attribute(:license_path, kind_of: String)
      attribute(:max_lease_ttl, kind_of: String)
      attribute(:raw_storage_endpoint, equal_to: [true, false])
      # Service Registration options
      attribute(:service_registration_type, equal_to: %w(consul kubernetes))
      attribute(:service_registration_options, option_collector: true)
      # Storage options
      attribute(:storage_type, default: 'inmem', equal_to: %w(consul etcd zookeeper dynamodb s3 mysql postgresql inmem file raft))
      attribute(:storage_options, option_collector: true)
      attribute(:unauthenticated_metrics_access, equal_to:[true, false], default: false)
      attribute(:utilization_reporting, equal_to:[true, false], default: false)
      attribute(:hastorage_type, kind_of: String)
      attribute(:hastorage_options, option_collector: true)
      # Telemetry options
      attribute(:telemetry_options, option_collector: true, default: {})
      # HA options
      attribute(:api_addr, kind_of: String)
      attribute(:cluster_addr, kind_of: String)
      attribute(:disable_clustering, equal_to: [true, false])
      # UI options
      attribute(:ui, equal_to: [true, false])

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
        config_keeps = %i(cluster_name cache_size disable_cache disable_mlock default_lease_ttl log_level max_lease_ttl raw_storage_endpoint ui license_path)
        config = to_hash.keep_if do |k, _|
          config_keeps.include?(k.to_sym)
        end
        # listener
        listener_keeps = %i(address cluster_address proxy_protocol_behavior proxy_protocol_authorized_addrs)
        tls_params = %i(tls_cert_file tls_key_file tls_min_version tls_cipher_suites tls_prefer_server_cipher_suites tls_require_and_verify_client_cert tls_client_ca_file tls_disable_client_certs)
        listener_keeps += tls_params if tls?
        listener_options = to_hash.keep_if do |k, _|
          listener_keeps.include?(k.to_sym)
        end.merge(tls_disable: tls_disable.to_s)
        if unauthenticated_metrics_access
          listener_telemetry = { 'telemetry' => { :unauthenticated_metrics_access => unauthenticated_metrics_access } }
          listener_options.merge!(listener_telemetry)
        end
        config['listener'] = { 'tcp' => listener_options }
        # service registration
        config['service_registration'] = { service_registration_type => (service_registration_options || {}) } if service_registration_type
        # storage
        config['storage'] = { storage_type => (storage_options || {}) }
        # ha_storage, only some storages support HA
        if %w(consul etcd zookeeper dynamodb).include? hastorage_type
          config['ha_storage'] = { hastorage_type => (hastorage_options || {}) }
        end
        config['telemetry'] = telemetry_options unless telemetry_options.empty?
        # HA config
        ha_keeps = %i(api_addr cluster_addr disable_clustering)
        config['reporting'] = { 'license' => { 'enabled' => utilization_reporting } }
        config.merge!(to_hash.keep_if do |k, _|
          ha_keeps.include?(k.to_sym)
        end)
        # `gsub` since we may have multiple `retry_join` stanzas:
        # https://www.vaultproject.io/docs/concepts/integrated-storage#retry_join-configuration
        JSON.pretty_generate(config, quirks_mode: true).gsub(/retry_join_\d+/, 'retry_join')
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
