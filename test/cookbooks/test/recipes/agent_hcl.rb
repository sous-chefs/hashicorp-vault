hashicorp_vault_install 'package' do
  action :upgrade
end

hashicorp_vault_config_global 'vault' do
  vault_mode :agent
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
end

hashicorp_vault_config_auto_auth 'method_aws' do
  entry_type :method
  type 'aws'
  options(
    'mount_path' => 'auth/aws-subaccount',
    'config' => {
      'type' => 'iam',
      'role' => 'foobar',
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
  type 'unix'
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

hashicorp_vault_config_template '/etc/vault/server.key' do
  options(
    'source' => '/etc/vault/server.key.ctmpl',
    'destination' => '/etc/vault/server.key'
  )
  sensitive false
end

hashicorp_vault_config_template '/etc/vault/server.crt' do
  options(
    'source' => '/etc/vault/server.crt.ctmpl',
    'destination' => '/etc/vault/server.crt'
  )
  sensitive false
end

hashicorp_vault_service 'vault-agent' do
  vault_mode :agent
  action %i(create enable)
end
