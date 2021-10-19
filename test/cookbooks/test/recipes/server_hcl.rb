hashicorp_vault_install 'package' do
  action :upgrade
end

hashicorp_vault_config_global 'vault' do
  sensitive false
  telemetry(
    statsite_address: '127.0.0.1:8125',
    disable_hostname: true
  )
  notifies :restart, 'hashicorp_vault_service[vault]', :delayed
  action :create
end

hashicorp_vault_config_listener 'tcp' do
  sensitive false
  type 'tcp'
  description 'Test TCP listener'
  options(
    'address' => '127.0.0.1:8200',
    'cluster_address' => '127.0.0.1:8201',
    'tls_cert_file' => '/opt/vault/tls/tls.crt',
    'tls_key_file' => '/opt/vault/tls/tls.key',
    'telemetry' => {
      'unauthenticated_metrics_access' => false,
    }
  )
  notifies :restart, 'hashicorp_vault_service[vault]', :delayed
end

hashicorp_vault_config_storage 'file' do
  sensitive false
  options(
    'path' => '/opt/vault/data'
  )
  description 'Test file storage'
  notifies :restart, 'hashicorp_vault_service[vault]', :delayed
end

hashicorp_vault_config_storage 'raft' do
  config_dir '/etc/vault.test.d'
  sensitive false
  type 'raft'
  options(
    'path' => '/opt/vault/data',
    'retry_join' => [
      {
        'leader_api_addr' => 'http://127.0.0.2:8200',
        'leader_ca_cert_file' => '/path/to/ca1',
        'leader_client_cert_file' => '/path/to/client/cert1',
        'leader_client_key_file' => 'path/to/client/key1',
      },
      {
        'leader_api_addr' => 'http://127.0.0.3:8200',
        'leader_ca_cert_file' => '/path/to/ca2',
        'leader_client_cert_file' => '/path/to/client/cert2',
        'leader_client_key_file' => 'path/to/client/key2',
      },
      {
        'leader_api_addr' => 'http://127.0.0.4:8200',
        'leader_ca_cert_file' => '/path/to/ca3',
        'leader_client_cert_file' => '/path/to/client/cert3',
        'leader_client_key_file' => 'path/to/client/key3',
      },
      {
        'auto_join' => 'provider=aws region=eu-west-1 tag_key=vault tag_value=... access_key_id=... secret_access_key=...',
      },
    ],
    'autopilot' => {
      'cleanup_dead_servers' => 'true',
      'last_contact_threshold' => '200ms',
      'last_contact_failure_threshold' => '10m',
      'max_trailing_logs' => 250,
      'min_quorum' => 5,
      'server_stabilization_time' => '10s',
    }
  )
  description 'Test raft storage'
  notifies :restart, 'hashicorp_vault_service[vault]', :delayed
end

hashicorp_vault_service 'vault' do
  action %i(create enable start)
end
