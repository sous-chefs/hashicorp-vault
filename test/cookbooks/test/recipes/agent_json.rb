hashicorp_vault_install 'package' do
  action :upgrade
end

hashicorp_vault_config 'vault' do
  config_file '/etc/vault.d/vault-agent.json'
  config(
    'log_level' => 'info',
    'vault' => {
      'address' => 'https://127.0.0.1:8200',
    },
    'auto_auth' => {
      'method' => [
        {
          'type' => 'approle',
          'config' => {
            'role_id_file_path' => '/etc/vault/role_id',
            'secret_id_file_path' => '/etc/vault/role_secret',
          },
        },
      ],
      'sinks' => [
        {
          'sink' => {
            'type' => 'file',
            'config' => {
              'path' => '/tmp/file-sink',
            },
          },
        },
      ],
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
        'source' => '/etc/vault.d/server.crt.ctmpl',
        'destination' => '/etc/vault.d/server.crt',
      },
      {
        'source' => '/etc/vault.d/server.key.ctmpl',
        'destination' => '/etc/vault.d/server.key',
      },
    ]
  )

  sensitive false
end

%w(crt key).each { |f| file "/etc/vault.d/server.#{f}.ctmpl" }

hashicorp_vault_service 'vault' do
  config_file '/etc/vault.d/vault-agent.json'
  vault_mode :agent

  action %i(create enable start)

  subscribes :restart, 'template[/etc/vault.d/vault-agent.json]', :delayed
end
