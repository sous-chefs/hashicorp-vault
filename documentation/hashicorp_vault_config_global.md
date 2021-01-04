# hashicorp_vault_config_global

[Back to resource list](../README.md#resources)

Creates vault server and agent global, cache, sentinel, telemetry and vault configuration HCL configuration stanzas

- (<https://www.vaultproject.io/docs/configuration#parameters>)
- (<https://www.vaultproject.io/docs/agent#configuration>)
- (<https://www.vaultproject.io/docs/agent/caching>)
- (<https://www.vaultproject.io/docs/configuration/sentinel>)
- (<https://www.vaultproject.io/docs/configuration/telemetry>)

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
| `config_file`          | String        | `/etc/vault.d/vault.hcl`         | Configuration file to generate stanza in                            |
| `cookbook`             | String        | `hashicorp-vault`                | Cookbook to source configuration file template from                 |
| `template`             | String        | `hcl.erb`                        | Template to use to generate the configuration file                  |
| `sensitive`            | True, False   | `true`                           | Set template to sensitive by default                                |
| `global`               | Hash          | `default_vault_config_hcl`       | Global configuration options                                        |
| `cache`                | Hash          | `{}`                             | Cache configuration options                                         |
| `sentinel`             | Hash          | `{}`                             | Sentinel configuration options                                      |
| `telemetry`            | Hash          | `{}`                             | Telemetry configuration options                                     |
| `vault`                | Hash          | `{}`                             | Vault configuration options                                         |

## Examples

```ruby
hashicorp_vault_config_global 'vault' do
  sensitive false
  telemetry(
    statsite_address: '127.0.0.1:8125',
    disable_hostname: true
  )

  action :create
end
```
