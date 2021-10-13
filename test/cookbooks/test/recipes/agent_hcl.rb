hashicorp_vault_install 'package' do
  action :upgrade
end

hashicorp_vault_config_global 'vault' do
  vault_mode :agent
  global(
    'log_level' => 'info'
  )
  cache(
    'use_auto_auth_token' => true
  )
  vault(
    'address' => 'https://127.0.0.1:8200'
  )

  sensitive false
  notifies :restart, 'hashicorp_vault_service[vault-agent]', :delayed
end

hashicorp_vault_config_auto_auth 'method_approle' do
  entry_type :method
  type 'approle'
  options(
    'config' => {
      'role_id_file_path' => '/etc/vault/role_id',
      'secret_id_file_path' => '/etc/vault/role_secret',
    }
  )
  sensitive false
end

hashicorp_vault_config_auto_auth 'sink_file_1' do
  entry_type :sink
  type 'file'
  path '/tmp/file-foo'
  sensitive false
end

hashicorp_vault_config_auto_auth 'sink_file_2' do
  entry_type 'sink'
  type 'file'
  path '/tmp/file-bar'
  options(
    'wrap_ttl' => '5m',
    'aad_env_var' => 'TEST_AAD_ENV',
    'dh_type' => 'curve25519',
    'dh_path' => '/tmp/file-foo-dhpath2'
  )
  sensitive false
end

hashicorp_vault_config_listener 'unix' do
  vault_mode :agent
  options(
    'address' => '/tmp/vault_agent_unix.sock',
    'tls_disable' => true
  )
  sensitive false
end

hashicorp_vault_config_listener 'tcp' do
  vault_mode :agent
  type 'tcp'
  options(
    'address' => '127.0.0.1:8100',
    'tls_disable' => true
  )
  sensitive false
end

%w(crt key).each { |f| file "/etc/vault.d/server.#{f}.ctmpl" }

hashicorp_vault_config_template '/etc/vault.d/server.key' do
  options(
    'source' => '/etc/vault.d/server.key.ctmpl'
  )
  sensitive false
end

hashicorp_vault_config_template '/etc/vault.d/server.crt' do
  options(
    'source' => '/etc/vault.d/server.crt.ctmpl'
  )
  sensitive false
end

hashicorp_vault_service 'vault-agent' do
  vault_mode :agent
  action %i(create enable start)
end
