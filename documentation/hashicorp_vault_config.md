# hashicorp_vault_config

[Back to resource list](../README.md#resources)

Creates a vault server or agent template JSON configuration

Introduced: v5.0.0

## Actions

- `:create`
- `:delete`

## Properties

| Name                   | Type          | Default                          | Description                                                         |
| ---------------------- | ------------- | -------------------------------- | ------------------------------------------------------------------- |
| `owner`                | String        | `vault`                          | Owner of the generated configuration file                           |
| `group`                | String        | `vault`                          | Group of the generated configuration file                           |
| `mode`                 | String        | `'0640'`                         | Filemode of the generated configuration file                        |
| `config_file`          | String        | `/etc/vault.d/vault.json`        | Configuration file to generate                                      |
| `sensitive`            | True, False   | `true`                           | Set template to sensitive by default                                |
| `config`               | Hash          | `{}`                             | Vault configuration                                                 |

## Examples

```ruby
hashicorp_vault_config 'vault' do
  sensitive false
  config(
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
    'ui' => true
  )

  action :create
end
```

```ruby
hashicorp_vault_config 'vault' do
  action :delete
  end
```
