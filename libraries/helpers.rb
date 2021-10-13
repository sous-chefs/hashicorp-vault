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

      def default_vault_config_dir
        '/etc/vault.d'
      end

      def default_vault_config_file(config_type)
        case config_type
        when :hcl
          vault_mode.eql?(:server) ? "#{config_dir}/#{vault_hcl_file_prefix}_#{name.gsub(' ', '_').downcase}.hcl" : '/etc/vault.d/vault.hcl'
        when :json
          '/etc/vault.d/vault.json'
        else
          raise ArgumentError, "default_vault_config_file: Invalid configuration type #{config_type}."
        end
      end

      def default_vault_config_json
        {
          'api_addr' => 'https://127.0.0.1:8200',
          'cluster_addr' => 'https://127.0.0.1:8201',
          'cache_size' => 131072,
          'default_lease_ttl' => '768h',
          'default_max_request_duration' => '90s',
          'disable_cache' => false,
          'disable_clustering' => false,
          'disable_mlock' => false,
          'disable_performance_standby' => true,
          'disable_sealwrap' => false,
          'listener' => {
            'tcp' => {
              'address' => '127.0.0.1:8200',
              'cluster_address' => '127.0.0.1:8201',
              'tls_cert_file' => '/opt/vault/tls/tls.crt',
              'tls_key_file' => '/opt/vault/tls/tls.key',
              'telemetry' => {
                'unauthenticated_metrics_access' => false,
              },
            },
          },
          'max_lease_ttl' => '768h',
          'raw_storage_endpoint' => false,
          'storage' => {
            'file' => {
              'path' => '/opt/vault/data',
            },
          },
          'ui' => true,
        }
      end

      def default_vault_config_hcl(section)
        case section
        when :global
          {
            'api_addr' => 'https://127.0.0.1:8200',
            'cluster_addr' => 'https://127.0.0.1:8201',
            'cache_size' => 131072,
            'default_lease_ttl' => '768h',
            'default_max_request_duration' => '90s',
            'disable_cache' => false,
            'disable_clustering' => false,
            'disable_mlock' => false,
            'disable_performance_standby' => true,
            'disable_sealwrap' => false,
            'max_lease_ttl' => '768h',
            'raw_storage_endpoint' => false,
            'ui' => true,
          }
        else
          {}
        end
      end

      def default_vault_service_name
        vault_mode.eql?(:server) ? 'vault' : 'vault-agent'
      end

      def default_vault_unit_content
        unit_content = {
          'Unit' => {
            'After' => [
              'network-online.target',
            ],
            'Description' => 'HashiCorp Vault - A tool for managing secrets',
            'Documentation' => 'https://www.vaultproject.io/docs/',
            'Requires' => 'network-online.target',
            'StartLimitIntervalSec' => 60,
            'StartLimitBurst' => 3,
          },
          'Service' => {
            'Type' => 'exec',
            'User' => user,
            'Group' => group,
            'ProtectSystem' => 'full',
            'ProtectHome' => 'read-only',
            'PrivateTmp' => 'yes',
            'PrivateDevices' => 'yes',
            'SecureBits' => 'keep-caps',
            'AmbientCapabilities' => 'CAP_IPC_LOCK',
            'CapabilityBoundingSet' => 'CAP_SYSLOG CAP_IPC_LOCK',
            'NoNewPrivileges' => 'yes',
            'ExecStart' => "#{vault_binary_path} #{vault_mode.to_s} -config=#{vault_mode.eql?(:server) ? config_dir : config_file}",
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

        case vault_mode
        when :server
          unit_content['Unit']['ConditionPathIsDirectory'] = [ config_dir ]
        when :agent
          unit_content['Unit']['ConditionFileNotEmpty'] = [ config_file ]
        end
        unit_content['Unit'] = unit_content['Unit'].sort.to_h

        unit_content
      end
    end
  end
end
