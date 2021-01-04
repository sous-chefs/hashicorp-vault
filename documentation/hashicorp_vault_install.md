# hashicorp_vault_install

[Back to resource list](../README.md#resources)

Installs vault from repository and package or via the [ark](https://supermarket.chef.io/cookbooks/ark) cookbook.

Introduced: v5.0.0

## Actions

- `:install`
- `:upgrade`
- `:remove`

## Properties

| Name                   | Type          | Default                          | Description                                                         |
| ---------------------- | ------------- | -------------------------------- | ------------------------------------------------------------------- |
| `user`                 | String        | `vault`                          | Vault run-as user                                                   |
| `group`                | String        | `vault`                          | Vault run-as group                                                  |
| `install_method`       | String, Symbol| `:repository`                    | Installation method to use                                          |
| `packages`             | String, Array | `[ 'vault' ]`                    | Packages to install for `:repository` installation method)          |
| `version`              | String        | `nil`                            | Version to install (required for `:ark` installation method)        |
| `url`                  | String        | `vault_source(version)`          | URL to fetch vault archive from for `:ark` installation method      |
| `checksum`             | Hash          | `nil`                            | Expected checksum of vault archive for `:ark` installation method   |

## Examples

```ruby
hashicorp_vault_install 'package' do
  action :upgrade
end
```
