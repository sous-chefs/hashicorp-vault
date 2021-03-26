hashicorp_vault_install 'package' do
  action :upgrade
end

hashicorp_vault_config_global 'vault' do
  sensitive false
  telemetry(
    statsite_address: '127.0.0.1:8125',
    disable_hostname: true
  )

  action :create
end

hashicorp_vault_config_listener 'tcp' do
  options(
    'address' => '127.0.0.1:8200',
    'cluster_address' => '127.0.0.1:8201',
    'tls_cert_file' => '/opt/vault/tls/tls.crt',
    'tls_key_file' => '/opt/vault/tls/tls.key',
    'telemetry' => {
      'unauthenticated_metrics_access' => false,
    }
  )
end

hashicorp_vault_config_storage 'Test file storage' do
  type 'file'
  options(
    'path' => '/opt/vault/data'
  )
end

hashicorp_vault_service 'vault' do
  action %i(create enable start)

  subscribes :restart, 'template[/etc/vault.d/vault.hcl]', :delayed
end
