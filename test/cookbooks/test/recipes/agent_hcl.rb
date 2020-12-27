hashicorp_vault_install 'package' do
  action :upgrade
end

hashicorp_vault_config_global 'vault' do
  global(
    'pid_file' => './pidfile'
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

hashicorp_vault_config_auto_auth 'aws' do
  type 'method'
  options(
    'mount_path' => 'auth/aws-subaccount',
    'config' => {
      'type' => 'iam',
      'role' => 'foobar',
    }
  )

  notifies :restart, 'hashicorp_vault_service[vault-agent]', :delayed
end

hashicorp_vault_config_auto_auth 'file' do
  type 'sink'
  options(
    'config' => {
      'path' => '/tmp/file-foo',
    }
  )

  notifies :restart, 'hashicorp_vault_service[vault-agent]', :delayed
end

hashicorp_vault_config_auto_auth 'file' do
  type 'sink'
  options(
    'wrap_ttl' => '5m',
    'aad_env_var' => 'TEST_AAD_ENV',
    'dh_type' => 'curve25519',
    'dh_path' => '/tmp/file-foo-dhpath2',
    'config' => {
      'path' => '/tmp/file-bar',
    }
  )

  notifies :restart, 'hashicorp_vault_service[vault-agent]', :delayed
end

hashicorp_vault_config_listener 'unix' do
  options(
    'address' => '/tmp/vault_agent_unix.sock',
    'tls_disable' => true
  )

  notifies :restart, 'hashicorp_vault_service[vault-agent]', :delayed
end

hashicorp_vault_config_listener 'tcp' do
  options(
    'address' => '127.0.0.1:8100',
    'tls_disable' => true
  )

  notifies :restart, 'hashicorp_vault_service[vault-agent]', :delayed
end

hashicorp_vault_config_template '/etc/vault/server.key' do
  options(
    'source' => '/etc/vault/server.key.ctmpl'
  )

  notifies :restart, 'hashicorp_vault_service[vault-agent]', :delayed
end

hashicorp_vault_config_template '/etc/vault/server.crt' do
  options(
    'source' => '/etc/vault/server.crt.ctmpl',
    'destination' => '/etc/vault/server.crt'
  )

  notifies :restart, 'hashicorp_vault_service[vault-agent]', :delayed
end

hashicorp_vault_service 'vault-agent' do
  mode :agent
  action %i(create enable start)
end
