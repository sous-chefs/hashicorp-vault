# hashicorp_vault_config_auto_auth

[Back to resource list](../README.md#resources)

Creates a vault agent automatic authentication HCL configuration stanza (<https://www.vaultproject.io/docs/agent/autoauth>)

Introduced: v5.0.0

## Actions

- `:create`
- `:delete`

## Properties

| Name          | Type           | Default                  | Description                                                               |
| ------------- | -------------- | ------------------------ | ------------------------------------------------------------------------- |
| `owner`       | String         | `vault`                  | Owner of the generated configuration file                                 |
| `group`       | String         | `vault`                  | Group of the generated configuration file                                 |
| `mode`        | String         | `'0640'`                 | Filemode of the generated configuration file                              |
| `config_file` | String         | `/etc/vault.d/vault.hcl` | Configuration file to generate stanza in                                  |
| `cookbook`    | String         | `hashicorp-vault`        | Cookbook to source configuration file template from                       |
| `template`    | String         | `hcl.erb`                | Template to use to generate the configuration file                        |
| `sensitive`   | True, False    | `true`                   | Set template to sensitive by default                                      |
| `type`        | String, Symbol | `nil`                    | Configuration stanza type                                                 |
| `entry_type`  | String, Symbol | `nil`                    | Configuration stanza sub-type (`:method` or `:sink`)                      |
| `path`        | String         | `nil`                    | Path setting for `:sink` types, will be merged with options automatically |
| `options`     | Hash           | `nil`                    | Options for the configuration stanza                                      |

## Examples

### Automatic authentication method

- <https://www.vaultproject.io/docs/agent/autoauth/methods>

```ruby
hashicorp_vault_config_auto_auth 'aws' do
  type 'method'
  options(
    'mount_path' => 'auth/aws-subaccount',
    'config' => {
      'type' => 'iam',
      'role' => 'foobar',
    }
  )
end
```

### Automatic authentication sink

- <https://www.vaultproject.io/docs/agent/autoauth/sinks>

```ruby
hashicorp_vault_config_auto_auth 'file' do
  type 'sink'
  options(
    'config' => {
      'path' => '/tmp/file-foo',
    }
  )
end
```

```ruby
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
end
```
