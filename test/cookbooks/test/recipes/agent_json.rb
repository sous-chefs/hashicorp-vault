hashicorp_vault_install 'package' do
  action :upgrade
end

hashicorp_vault_config 'vault' do
  config_file '/etc/vault.d/vault-agent.json'
  config(
    'pid_file' => './pidfile',
    'vault' => {
      'address' => 'https://127.0.0.1:8200',
    },
    'auto_auth' => {
      'method' => {
        'aws' => {
          'mount_path' => 'auth/aws-subaccount',
          'config' => {
            'type' => 'iam',
            'role' => 'foobar',
          },
        },
      },
      'sink' => {
        'file' => [
          {
            'config' => {
              'path' => '/tmp/file-sink',
            },
          },
          {
            'wrap_ttl' => '5m',
            'aad_env_var' => 'TEST_AAD_ENV',
            'dh_type' => 'curve25519',
            'dh_path' => '/tmp/file-foo-dhpath2',
            'config' => {
              'path' => '/tmp/file-bar',
            },
          },
        ],
      },
    },
    'cache' => {
      'use_auto_auth_token' => true,
    },
    'listener' => {
      'unix' => {
        'address' => '/tmp/vault_agent_unix.sock',
        'tls_disable' => true,
      },
      'tcp' => {
        'address' => '127.0.0.1:8100',
        'tls_disable' => true,
      },
    },
    'template' => [
      {
        'source' => '/etc/vault/server.crt.ctmpl',
        'destination' => '/etc/vault/server.crt',
      },
      {
        'source' => '/etc/vault/server.key.ctmpl',
        'destination' => '/etc/vault/server.key',
      },
    ]
  )

  sensitive false
end

hashicorp_vault_service 'vault' do
  config_file '/etc/vault.d/vault-agent.json'
  vault_mode :agent

  action %i(create enable start)

  subscribes :restart, 'template[/etc/vault.d/vault-agent.json]', :delayed
end
