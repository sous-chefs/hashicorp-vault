module Vault
  module Cookbook
    module Helpers
      def default_vault_user
        'vault'
      end

      def default_vault_group
        'vault'
      end

      def default_vault_packages
        %w(vault)
      end

      def default_vault_config_file
        '/etc/vault.d/vault.json'
      end

      def default_vault_service_name
        'vault'
      end

      def default_vault_unit_content
        {
          'Unit' => {
            'Description' => '"HashiCorp Vault - A tool for managing secrets"',
            'Documentation' => 'https://www.vaultproject.io/docs/',
            'Requires' => 'network-online.target',
            'After' => [
              'network-online.target',
            ],
            'ConditionFileNotEmpty' => [
              '/etc/vault.d/vault.json',
            ],
            'StartLimitIntervalSec' => 60,
            'StartLimitBurst' => 3,
          },
          'Service' => {
            'User' => vault_user,
            'Group' => vault_group,
            'ProtectSystem' => 'full',
            'ProtectHome' => 'read-only',
            'PrivateTmp' => 'yes',
            'PrivateDevices' => 'yes',
            'SecureBits' => 'keep-caps',
            'AmbientCapabilities' => 'CAP_IPC_LOCK',
            'CapabilityBoundingSet' => 'CAP_SYSLOG CAP_IPC_LOCK',
            'NoNewPrivileges' => 'yes',
            'ExecStart' => "/usr/bin/vault server -config=#{config_file}",
            'ExecReload' => '/bin/kill --signal HUP $MAINPID',
            'KillMode' => 'process',
            'KillSignal' => 'SIGINT',
            'Restart' => 'on-failure',
            'RestartSec' => 5,
            'TimeoutStopSec' => 30,
            'StartLimitInterval' => 60,
            'StartLimitBurst' => 3,
            'LimitNOFILE' => 65536,
            'LimitMEMLOCK' => 'infinity',
          },
          'Install' => {
            'WantedBy' => 'multi-user.target',
          },
        }
      end
    end
  end
end
