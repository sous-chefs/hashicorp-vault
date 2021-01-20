# Upgrading

This document will give you help on upgrading major versions of hashicorp_vault

## 5.0.0

Version 5.0.0 is a major rewrite of the cookbook to current standards.

- Remodel fully as a resource library cookbook.
- Unified configuration resources, the same resources are to be used for both server and agent configuration.

### Removed

- All attributes
- Resource `hashicorp_vault_install_dist`
- Resource `hashicorp_vault_agent_config`
- Resource `hashicorp_vault_agent_install`
- Resource `hashicorp_vault_agent_template`

### Added

- HCL configuration support

#### Configuration Resources - HCL

- `hashicorp_vault_config_auto_auth` - [Documentation](./documentation/hashicorp_vault_config_auto_auth.md)
- `hashicorp_vault_config_entropy` - [Documentation](./documentation/hashicorp_vault_config_entropy.md)
- `hashicorp_vault_config_global` - [Documentation](./documentation/hashicorp_vault_config_global.md)
- `hashicorp_vault_config_listener` - [Documentation](./documentation/hashicorp_vault_config_listener.md)
- `hashicorp_vault_config_seal` - [Documentation](./documentation/hashicorp_vault_config_seal.md)
- `hashicorp_vault_config_service_registration` - [Documentation](./documentation/hashicorp_vault_config_service_registration.md)
- `hashicorp_vault_config_storage` - [Documentation](./documentation/hashicorp_vault_config_storage.md)
- `hashicorp_vault_config_template` - [Documentation](./documentation/hashicorp_vault_config_template.md)

#### Configuration - HCL

- `hashicorp_vault_config_global` should always be used to add the base configuration settings for a vault configuration
- The compilation and convergence of *any* of the `hashicorp_vault_config_*` resources will result in the instantiation of the accumulated template to the create the HCL configuration file
- Due to the above it is possible to create a configuration file elements missing that are required for vault operation, see the vault documentation for details on which configuration items and thus resources you will require.

### Changed

#### Common

- Custom resources have been rewritten in current style.
- Vault configuration items that were previously represented as individual Chef resource properties have been moved to a single `options` Hash property.
- Unified configuration resources - the same resources are used for both `server` and `agent` mode.

#### Install

- The `hashicorp_vault_install` resource is no longer an AIO resource and will *not* configure vault nor create the service.
- Previous use of the install resource should be migrated to a wrapper recipe with install, configuration and service management implemented by the user.

#### Configuration - JSON

- The `hashicorp_vault_config` resource should be implemented for users who wish to continue using Vault with `json` configuration format.
- All resource properties and values should be migrated to the `config` Hash property.

#### Agent Configuration

- Vault can be configured in `agent` mode with a `json` configuration by the use of `hashicorp_vault_config`, with the `config_file` property overridden if server and agent mode are to co-exist.
- The vault agent service can be managed via `hashicorp_vault_service` with the `mode` property set to `:agent`.
