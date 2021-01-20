# hashicorp_vault_service

[Back to resource list](../README.md#resources)

Creates a vault server or agent template JSON configuration

Introduced: v5.0.0

## Actions

- `:create`
- `:delete`
- `:start`
- `:stop`
- `:restart`
- `:reload`
- `:enable`
- `:disable`

## Properties

| Name                   | Type          | Default                          | Description                                                         |
| ---------------------- | ------------- | -------------------------------- | ------------------------------------------------------------------- |
| `service_name`         | String        | `vault`                          | Vault service name                                                  |
| `config_type`          | Symbol, String| `:hcl`                           | Vault configuration type                                            |
| `systemd_unit_content` | String, Hash  | `default_vault_unit_content`     | Vault service systemd unit file content                             |
| `user`                 | String        | `vault`                          | Vault run-as user                                                   |
| `group`                | String        | `vault`                          | Vault run-as group                                                  |
| `config_file`          | String        | `/etc/vault.d/vault.(hcl\|json)` | Configuration file                                                  |
| `mode`                 | Symbol, String| `:server`                        | Vault service operation type                                        |

## Examples

### HCL Server

```ruby
hashicorp_vault_service 'vault' do
  action %i(create enable start)
end
```

### JSON Server

```ruby
hashicorp_vault_service 'vault' do
  config_type :json
  action %i(create enable start)
end
```

### HCL Agent

```ruby
hashicorp_vault_service 'vault-agent' do
  mode :agent

  action %i(create enable start)
end
```
