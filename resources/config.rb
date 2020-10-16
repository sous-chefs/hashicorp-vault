include Vault::Cookbook::Helpers

property :config_location, String,
         name_property: true,
         description: 'Set to override default config location. Defaults to /etc/vault/vault.json'

property :vault_user, String,
         default: 'vault',
         description: 'Set to override default vault user. Defaults to vault.'

property :vault_group, String,
         default: 'vault',
         description: 'Set to override default vault group. Defaults to vault.'

property :storage_type, String,
         default: 'file',
         description: 'Type of storage backend utilized.'

property :storage_options, Hash,
         default: { path: '/mnt/vault/data' },
         description: 'Ruby hash containing options corresponding to appropriate storage backend type.'

property :seal_type, String,
         description: 'Type of seal utilized.'

property :seal_options, Hash,
         default: {},
         description: 'Ruby hash containing options corresponding to appropriate seal type.'

property :ha_storage
property :tls_address, String,
         default: '127.0.0.1:8200',
         description: 'Specifies the address to bind to for listening.'

property :tls_cluster_address, String,
         default: '127.0.0.1:8201',
         description: 'Specifies the address to bind to for cluster server-to-server requests. This defaults to one port higher than the value of address. This does not usually need to be set, but can be useful in case Vault servers are isolated from each other in such a way that they need to hop through a TCP load balancer or some other scheme in order to talk.'

property :tls_max_request_size, [Integer, String],
         coerce: proc { |m| m.is_a?(Integer) ? m.to_s : m },
         default: 33554432,
         description: 'Specifies a hard maximum allowed request size, in bytes. Defaults to 32 MB. Specifying a number less than or equal to 0 turns off limiting altogether.'

property :tls_max_request_duration, String,
         default: '90s',
         description: 'Specifies the maximum request duration allowed before Vault cancels the request. This overrides default_max_request_duration for this listener.'

property :tls_proxy_protocol_behavior, [nil, String],
         equal_to: [nil, 'use_always', 'allow_authorized', 'deny_authorized'],
         description: ' When specified, enables a PROXY protocol version 1 behavior for the listener.'

property :tls_proxy_protocol_authorized_addrs, [String, Array],
         description: 'Specifies the list of allowed source IP addresses to be used with the PROXY protocol. Not required if proxy_protocol_behavior is set to use_always. Source IPs should be comma-delimited if provided as a string. At least one source IP must be provided, proxy_protocol_authorized_addrs cannot be an empty array or string.'

property :tls_disable, [true, false],
         default: false,
         description: 'Specifies if TLS will be disabled. Vault assumes TLS by default, so you must explicitly disable TLS to opt-in to insecure communication.'

property :tls_cert_file, String,
         description: 'Specifies the path to the certificate for TLS. To configure the listener to use a CA certificate, concatenate the primary certificate and the CA certificate together. The primary certificate should appear first in the combined file. On SIGHUP, the path set here at Vault startup will be used for reloading the certificate; modifying this value while Vault is running will have no effect for SIGHUPs.'

property :tls_key_file, String,
         description: ' Specifies the path to the private key for the certificate. If the key file is encrypted, you will be prompted to enter the passphrase on server startup. The passphrase must stay the same between key files when reloading your configuration using SIGHUP. On SIGHUP, the path set here at Vault startup will be used for reloading the certificate; modifying this value while Vault is running will have no effect for SIGHUPs.'

property :tls_min_version, String,
         default: 'tls12',
         equal_to: %w(tls10 tls11 tls12),
         description: 'Specifies the minimum supported version of TLS.'

property :tls_cipher_suites, String,
         description: 'Specifies the list of supported ciphersuites as a comma-separated-list. The list of all available ciphersuites is available in the Golang TLS documentation.'

property :tls_client_ca_file, String,
         description: 'PEM-encoded Certificate Authority file used for checking the authenticity of client.'

property :tls_disable_client_certs, [true, false],
         default: false,
         description: 'Turns off client authentication for this listener. The default behavior (when this is false) is for Vault to request client certificates when available.'

property :tls_prefer_server_cipher_suites, [true, false],
         default: false,
         description: 'Specifies to prefer the server\'s ciphersuite over the client ciphersuites.'

property :tls_require_and_verify_client_cert, [true, false],
         default: false,
         description: 'Turns on client authentication for this listener; the listener will require a presented client cert that successfully validates against system CAs.'

property :tls_x_forwarded_for_authorized_addrs, String,
         description: 'Specifies the list of source IP CIDRs for which an X-Forwarded-For header will be trusted. Comma-separated list or JSON array. This turns on X-Forwarded-For support.'

property :tls_x_forwarded_for_hop_skips, String,
         default: '0',
         description: 'The number of addresses that will be skipped from the rear of the set of hops. For instance, for a header value of 1.2.3.4, 2.3.4.5, 3.4.5.6, if this value is set to "1", the address that will be used as the originating client IP is 2.3.4.5.'

property :tls_x_forwarded_for_reject_not_authorized, [true, false],
         default: true,
         description: 'If set false, if there is an X-Forwarded-For header in a connection from an unauthorized address, the header will be ignored and the client connection used as-is, rather than the client connection rejected.'

property :tls_x_forwarded_for_reject_not_present, [true, false],
         default: true,
         description: 'If set false, if there is no X-Forwarded-For header or it is empty, the client address will be used as-is, rather than the client connection rejected.'

property :unauthenticated_metrics_access, [true, false],
         default: false,
         description: 'If set false, /v1/sys/metrics telemetry endpoint will require authentication.'

property :cluster_name, String,
         description: 'Specifies the identifier for the Vault cluster. If omitted, Vault will generate a value. When connecting to Vault Enterprise, this value will be used in the interface.'

property :cache_size, [Integer, String],
         coerce: proc { |m| m.is_a?(Integer) ? m.to_s : m },
         default: 32000,
         description: 'Specifies the size of the read cache used by the physical storage subsystem. The value is in number of entries, so the total cache size depends on the size of stored entries.'

property :disable_cache, [true, false],
         default: false,
         description: 'Disables all caches within Vault, including the read cache used by the physical storage subsystem. This will very significantly impact performance.'

property :disable_mlock, [true, false],
         default: false,
         description: 'Disables the server from executing the mlock syscall. mlock prevents memory from being swapped to disk. Disabling mlock is not recommended in production, but is fine for local development and testing.'

property :plugin_directory, String,
         description: ' A directory from which plugins are allowed to be loaded. Vault must have permission to read files in this directory to successfully load plugins.'

property :telemetry, Hash,
         description: 'Specifies the telemetry reporting system.'

property :log_level, String,
         equal_to: %w(Trace Debug Error Warn Info),
         description: 'Specifies the log level to use; overridden by CLI and env var parameters. On SIGHUP, Vault will update the log level to the current value specified here (including overriding the CLI/env var parameters). Not all parts of Vault\'s logging can have its level be changed dynamically this way; in particular, secrets/auth plugins are currently not updated dynamically. Supported log levels: Trace, Debug, Error, Warn, Info.'

property :default_lease_ttl, String,
         default: '768h',
         description: 'Specifies the default lease duration for tokens and secrets. This is specified using a label suffix like "30s" or "1h". This value cannot be larger than max_lease_ttl.'

property :max_lease_ttl, String,
         default: '768h',
         description: 'Specifies the maximum possible lease duration for tokens and secrets. This is specified using a label suffix like "30s" or "1h".'

property :default_max_request_duration, String,
         default: '90s',
         description: 'Specifies the default maximum request duration allowed before Vault cancels the request. This can be overridden per listener via the max_request_duration value.'

property :raw_storage_endpoint, [true, false],
         default: false,
         description: 'Enables the sys/raw endpoint which allows the decryption/encryption of raw data into and out of the security barrier. This is a highly privileged endpoint.'

property :ui, [true, false],
         default: false,
         description: 'Enables the built-in web UI, which is available on all listeners (address + port) at the /ui path. Browsers accessing the standard Vault API address will automatically redirect there. This can also be provided via the environment variable VAULT_UI. For more information, please see the ui configuration documentation.'

property :max_open_files, Integer,
         default: 16384,
         description: 'Max open file descriptors than can be used by Vault'

property :pid_file, String,
         description: ' Path to the file in which the Vault server\'s Process ID (PID) should be stored.'
property :api_addr, String,
         description: 'Specifies the address (full URL) to advertise to other Vault servers in the cluster for client redirection. This value is also used for plugin backends. This can also be provided via the environment variable VAULT_API_ADDR. In general this should be set as a full URL that points to the value of the listener address.'

property :cluster_addr, String,
         description: 'Specifies the address to advertise to other Vault servers in the cluster for request forwarding. This can also be provided via the environment variable VAULT_CLUSTER_ADDR. This is a full URL, like api_addr, but Vault will ignore the scheme (all cluster members always use TLS with a private key/certificate).'

property :disable_clustering, [true, false],
         default: false,
         description: 'Specifies whether clustering features such as request forwarding are enabled. Setting this to true on one Vault node will disable these features only when that node is the active node.'

property :disable_sealwrap, [true, false],
         default: false,
         description: 'Disables using seal wrapping for any value except the master key. If this value is toggled, the new behavior will happen lazily (as values are read or written).'

property :disable_performance_standby, [true, false],
         default: false,
         description: ' Specifies whether performance standbys should be disabled on this node. Setting this to true on one Vault node will disable this feature when this node is Active or Standby. It\'s recomended to sync this setting across all nodes in the cluster.'

property :sensitive, [true, false],
         default: false,
         description: 'Ensure that sensitive resource data is not logged by Chef Infra Client.'

action :configure do
  require 'json'

  directory ::File.dirname(new_resource.config_location) do
    owner new_resource.vault_user
    group new_resource.vault_group
    mode '0740'
    action :create
  end

  tcp_hash = {
    address: new_resource.tls_address,
    cluster_address: new_resource.tls_cluster_address,
    max_request_size: new_resource.tls_max_request_size,
    max_request_duration: new_resource.tls_max_request_duration,
    tls_disable: new_resource.tls_disable,
    telemetry: {
      unauthenticated_metrics_access: new_resource.unauthenticated_metrics_access,
    },
  }

  tcp_hash['proxy_protocol_behavior']                   = new_resource.tls_proxy_protocol_behavior unless new_resource.tls_proxy_protocol_behavior.nil?
  tcp_hash['proxy_protocol_authorized_addrs']           = new_resource.tls_proxy_protocol_authorized_addrs unless new_resource.tls_proxy_protocol_behavior.nil?
  tcp_hash['tls_cert_file']                             = new_resource.tls_cert_file unless new_resource.tls_disable
  tcp_hash['tls_key_file']                              = new_resource.tls_key_file unless new_resource.tls_disable
  tcp_hash['tls_min_version']                           = new_resource.tls_min_version unless new_resource.tls_disable
  tcp_hash['tls_cipher_suites']                         = new_resource.tls_cipher_suites unless new_resource.tls_disable || new_resource.tls_cipher_suites.nil?
  tcp_hash['tls_prefer_server_cipher_suites']           = new_resource.tls_prefer_server_cipher_suites unless new_resource.tls_disable || new_resource.tls_prefer_server_cipher_suites.nil?
  tcp_hash['tls_require_and_verify_client_cert']        = new_resource.tls_require_and_verify_client_cert unless new_resource.tls_disable || new_resource.tls_require_and_verify_client_cert.nil?
  tcp_hash['tls_client_ca_file']                        = new_resource.tls_client_ca_file unless new_resource.tls_disable || new_resource.tls_client_ca_file.nil?
  tcp_hash['tls_disable_client_certs']                  = new_resource.tls_disable_client_certs unless new_resource.tls_disable
  tcp_hash['tls_x_forwarded_for_authorized_addrs']      = new_resource.tls_x_forwarded_for_authorized_addrs unless new_resource.tls_disable || new_resource.tls_x_forwarded_for_authorized_addrs.nil?
  tcp_hash['tls_x_forwarded_for_hop_skips']             = new_resource.tls_x_forwarded_for_hop_skips unless new_resource.tls_disable || new_resource.tls_x_forwarded_for_authorized_addrs.nil?
  tcp_hash['tls_x_forwarded_for_reject_not_authorized'] = new_resource.tls_x_forwarded_for_reject_not_authorized unless new_resource.tls_disable || new_resource.tls_x_forwarded_for_authorized_addrs.nil?
  tcp_hash['tls_x_forwarded_for_reject_not_present']    = new_resource.tls_x_forwarded_for_reject_not_present unless new_resource.tls_disable || new_resource.tls_x_forwarded_for_authorized_addrs.nil?

  storage_hash = {
    "#{new_resource.storage_type}": new_resource.storage_options,
  }

  seal_hash = {
    "#{new_resource.seal_type}": new_resource.seal_options,
  }

  # TODO: Support multiple listeners
  config_hash = {
    listener: {
      tcp: tcp_hash,
    },
    backend: storage_hash,
    ui: new_resource.ui,
  }

  config_hash['cluster_name']                 = new_resource.cluster_name unless new_resource.cluster_name.nil?
  config_hash['cache_size']                   = new_resource.cache_size unless new_resource.cache_size.nil?
  config_hash['disable_cache']                = new_resource.disable_cache unless new_resource.disable_cache.nil?
  config_hash['disable_mlock']                = new_resource.disable_mlock unless new_resource.disable_mlock.nil?
  config_hash['plugin_directory']             = new_resource.plugin_directory unless new_resource.plugin_directory.nil?
  config_hash['log_level']                    = new_resource.log_level unless new_resource.log_level.nil?
  config_hash['default_lease_ttl']            = new_resource.default_lease_ttl unless new_resource.default_lease_ttl.nil?
  config_hash['max_lease_ttl']                = new_resource.max_lease_ttl unless new_resource.max_lease_ttl.nil?
  config_hash['default_max_request_duration'] = new_resource.default_max_request_duration unless new_resource.default_max_request_duration.nil?
  config_hash['raw_storage_endpoint']         = new_resource.raw_storage_endpoint unless new_resource.raw_storage_endpoint.nil?
  config_hash['pid_file']                     = new_resource.pid_file unless new_resource.cluster_name.nil?
  config_hash['api_addr']                     = new_resource.api_addr unless new_resource.api_addr.nil?
  config_hash['cluster_addr']                 = new_resource.cluster_addr unless new_resource.cluster_addr.nil?
  config_hash['disable_clustering']           = new_resource.disable_clustering unless new_resource.disable_clustering.nil?
  config_hash['disable_sealwrap']             = new_resource.disable_sealwrap unless new_resource.disable_sealwrap.nil?
  config_hash['disable_performance_standby']  = new_resource.disable_performance_standby unless new_resource.disable_performance_standby.nil?
  config_hash['telemetry']                    = new_resource.telemetry unless new_resource.telemetry.nil?

  config_hash['seal'] = seal_hash unless new_resource.seal_type.nil?

  file new_resource.config_location do
    content JSON.pretty_generate(Hash[config_hash.sort_by { |key, _val| key.to_s }])
    owner new_resource.vault_user
    group new_resource.vault_group
    mode '0640'
    sensitive new_resource.sensitive
    action :create
  end

  if new_resource.storage_type == 'file'
    directory new_resource.storage_options[:path] do
      owner new_resource.vault_user
      group new_resource.vault_group
      mode '0640'
      recursive true
      action :create
    end
  end
end

action :remove do
  file new_resource.config_location do
    action :delete
  end
end

action_class do
  include Vault::Cookbook::Helpers
end
