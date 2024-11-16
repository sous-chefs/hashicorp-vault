# Change Log

All notable changes to this project will be documented in this file.

## Unreleased

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

## 6.3.19 - *2024-07-15*

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

## 6.3.18 - *2024-05-02*

## 6.3.17 - *2024-05-02*

## 6.3.16 - *2023-10-03*

## 6.3.15 - *2023-09-04*

## 6.3.14 - *2023-09-04*

## 6.3.13 - *2023-05-16*

## 6.3.12 - *2023-05-03*

## 6.3.11 - *2023-04-07*

Standardise files with files in sous-chefs/repo-management

## 6.3.10 - *2023-04-01*

## 6.3.9 - *2023-04-01*

## 6.3.8 - *2023-04-01*

Standardise files with files in sous-chefs/repo-management

## 6.3.7 - *2023-03-20*

Standardise files with files in sous-chefs/repo-management

## 6.3.6 - *2023-03-15*

Standardise files with files in sous-chefs/repo-management

## 6.3.5 - *2023-03-02*

Standardise files with files in sous-chefs/repo-management

## 6.3.4 - *2023-02-27*

Standardise files with files in sous-chefs/repo-management

## 6.3.3 - *2023-02-23*

Standardise files with files in sous-chefs/repo-management

## 6.3.2 - *2023-02-15*

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

## 6.3.1 - *2022-02-08*

- Remove delivery folder
- Standardise files with files in sous-chefs/repo-management
- Update tested platforms
- Update Test Kitchen provisioner settings
- Remove .delivery folder
- Move to calling RSpec directly via a reusable workflow

## 6.3.0 - *2021-10-19*

- Unify `:type` property as name_property in partial

## 6.2.0 - *2021-10-19*

- Use `new_resource.name` as `type` part 2

## 6.1.0 - *2021-10-13*

- Use `new_resource.name` as `type`

## 6.0.3 - *2021-08-30*

- Standardise files with files in sous-chefs/repo-management

## 6.0.2 - *2021-06-18*

- Un-vendor hcl-checker gem

## 6.0.1 - *2021-06-01*

- Standardise files with files in sous-chefs/repo-management

## 6.0.0 - *2021-05-25*

**Breaking changes, please see [UPGRADING.md](./UPGRADING.md).**

- Chef 16 is now required
  - Resource partials now in use
- Refactor all HCL resources to use `load_current_value` and `converge_if_changed`
  - Resource notifications now function as per the core resources
  - Changed values are displayed and can be reported upon
  - Server configuration items are written to indiviual files
  - Agent configuration is still accumulated as per previous versions
- Refactor json configuration resource to use `load_current_value` and `converge_if_changed`

## 5.3.1 - *2021-05-11*

## 5.3.0 - *2021-03-26*

- Refactor service action to use standard action and allow multiple actions - [@bmhughes](https://github.com/bmhughes)

## 5.2.0 - *2021-02-09*

- Support ark installation for aarch64/i386/x86_64 architectures

## 5.1.0 - *2021-02-08*

- Added ark installation method support for Amazon Linux

## 5.0.2 - *2021-02-03*

- Update metadata supported platforms

## 5.0.1 - *2021-01-20*

- Update supporting files (<https://github.com/sous-chefs/vault/pull/211>)

## 5.0.0 - *2021-01-20*

**Breaking changes, please see [UPGRADING.md](./UPGRADING.md).**

- Add service resource
- Add package installation to install resource
- HCL configuration support
  - Unify server and agent under common resources.
  - Add HCL server configuration resources.
  - HCL configuration file as accumulated template.
  - HCL support for agent configuration.

- JSON configuration changes
  - Remove configuration properties and consolidate configuration in a `config` Hash property to allow new configuration items to be added without requiring a cookbook change.
  - Add base default configuration similar to vault defaults
  - Set sensitive by default

## 4.3.0 (2020-10-19)

- Added 'unauthenticated_metrics_access' config option

## 4.2.0 (2020-08-11)

- Created hashicorp_vault_agent_install resource
- Created hashicorp_vault_agent_template resource
- Created hashicorp_vault_agent_config resource
- Updated hashicorp_vault_service resource to be configurable for vault agent and server
- Set vault default version to 1.4.1

## 4.1.0 (2020-05-14)

- resolved cookstyle error: resources/config.rb:211:66 convention: `Layout/TrailingWhitespace`
- resolved cookstyle error: resources/config.rb:211:67 refactor: `ChefModernize/FoodcriticComments`
- resolved cookstyle error: resources/config.rb:215:60 convention: `Layout/TrailingWhitespace`
- resolved cookstyle error: resources/config.rb:215:61 refactor: `ChefModernize/FoodcriticComments`
- Resource config now supports property `max_open_files` to tune LimitNOFILE in Systemd unit file. Value is 16384 by default.

## v4.0.1 (2020-02-20)

- Runtime directory of 0740 on the systemd
- Telemetry configuration no longer recieves the correct configuration.

## v4.0.0 (2020-01-26)

- Option to specify configuration as sensitive via property
- Switched to GitHub Actions
- Rewrote all resources to be custom resource sso there's no longer a dependency on poise

## v3.0.2 (2019-06-11)

- Changes the function names for `config_prefix_path` and `data_path`

## v3.0.1 (2019-06-01)

- added `x_forwarded_for_*` and `cluster_addr` config options
- disabled unit tests as we cannot bundle install currently
- upgrade to chef 13 minimum
- migrate to circleci 2.0 testing
- added option to set `plugin_directory`

## v3.0.0 (2018-12-09)

- added options to set `seal` options, `ui`, and `disable_performance_standby`
- updated tests to test new config options
- added Circle CI tests
- removed support for Ubuntu 12.04 as it's EOL-ed
- added Ubuntu 18.04 tests

## v2.5.0 (2017-03-27)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v2.4.0...v2.5.0)

- undefined method `cluster\_address' for VaultCookbook::Resource::VaultConfig [\#93](https://github.com/johnbellone/vault-cookbook/issues/93)
- Service Logging [\#89](https://github.com/johnbellone/vault-cookbook/issues/89)
- disable\_cache option [\#84](https://github.com/johnbellone/vault-cookbook/issues/84)
- CentOS-\- kitchen tests fail w/ sudo issue [\#78](https://github.com/johnbellone/vault-cookbook/issues/78)
- Vault archive download address should be configurable [\#74](https://github.com/johnbellone/vault-cookbook/issues/74)
- Vault 0.5.3 -\> 0.6.0 is breaking. Cookbook major version should have been rev'd. [\#70](https://github.com/johnbellone/vault-cookbook/issues/70)
- Initializing and unsealing [\#69](https://github.com/johnbellone/vault-cookbook/issues/69)
- Added shasums for vault 0.6.4 and 0.6.5 [\#94](https://github.com/johnbellone/vault-cookbook/pull/94) ([onetwopunch](https://github.com/onetwopunch))
- Update test configuration, fix Travis builds [\#92](https://github.com/johnbellone/vault-cookbook/pull/92) ([legal90](https://github.com/legal90))
- fix typo in error message [\#90](https://github.com/johnbellone/vault-cookbook/pull/90) ([chrisminton](https://github.com/chrisminton))
- add additional ssl options to vault\_secret [\#88](https://github.com/johnbellone/vault-cookbook/pull/88) ([chrisminton](https://github.com/chrisminton))
- Vault 0.6.3 [\#87](https://github.com/johnbellone/vault-cookbook/pull/87) ([vijaybandari](https://github.com/vijaybandari))
- Fixes foodcritic, previous fix caused all checks to be ignored [\#86](https://github.com/johnbellone/vault-cookbook/pull/86) ([madeddie](https://github.com/madeddie))
- Add disable\_cache config option [\#85](https://github.com/johnbellone/vault-cookbook/pull/85) ([madeddie](https://github.com/madeddie))
- Add log-level support for service [\#82](https://github.com/johnbellone/vault-cookbook/pull/82) ([vijaybandari](https://github.com/vijaybandari))
- Update Changelog [\#81](https://github.com/johnbellone/vault-cookbook/pull/81) ([legal90](https://github.com/legal90))
- Enable passwordless sudo for tests [\#80](https://github.com/johnbellone/vault-cookbook/pull/80) ([legal90](https://github.com/legal90))
- Add 0.6.2 support [\#79](https://github.com/johnbellone/vault-cookbook/pull/79) ([Ginja](https://github.com/Ginja))
- Add cluster\_address for listener options [\#77](https://github.com/johnbellone/vault-cookbook/pull/77) ([freimer](https://github.com/freimer))
- Refactor integration tests and Travis CI configuration [\#75](https://github.com/johnbellone/vault-cookbook/pull/75) ([legal90](https://github.com/legal90))
- Fix init script syntax for compatibility with RHEL/CentOS  5 [\#73](https://github.com/johnbellone/vault-cookbook/pull/73) ([legal90](https://github.com/legal90))
- Add support of Vault 0.6.1 [\#71](https://github.com/johnbellone/vault-cookbook/pull/71) ([legal90](https://github.com/legal90))
- Create/Delete symbolic link to /usr/local/bin [\#68](https://github.com/johnbellone/vault-cookbook/pull/68) ([dpattmann](https://github.com/dpattmann))
- Add default recipe to kitchen run\_list [\#67](https://github.com/johnbellone/vault-cookbook/pull/67) ([dpattmann](https://github.com/dpattmann))
- Remove 'godep restore' for vault versions \> 0.5.0 [\#66](https://github.com/johnbellone/vault-cookbook/pull/66) ([dpattmann](https://github.com/dpattmann))

## v2.4.0 (2016-06-24)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v2.3.0...v2.4.0)

- Service doesn't come back after reboot because the default service directory is missing [\#55](https://github.com/johnbellone/vault-cookbook/issues/55)
- Failing to run service as nonroot [\#54](https://github.com/johnbellone/vault-cookbook/issues/54)
- Vault 0.6.0 [\#65](https://github.com/johnbellone/vault-cookbook/pull/65) ([axtl](https://github.com/axtl))
- Create work dir before service starts as it does not persist across restarts [\#64](https://github.com/johnbellone/vault-cookbook/pull/64) ([willejs](https://github.com/willejs))
- Liberate "build-essential" version constraint [\#63](https://github.com/johnbellone/vault-cookbook/pull/63) ([legal90](https://github.com/legal90))
- vault\_secret: Raise an exception if Vault read has failed [\#61](https://github.com/johnbellone/vault-cookbook/pull/61) ([legal90](https://github.com/legal90))

## v2.3.0 (2016-06-09)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v2.2.0...v2.3.0)

- What are bag\_name, bag\_item attributes used for? [\#58](https://github.com/johnbellone/vault-cookbook/issues/58)
- Test against newer build-essential [\#57](https://github.com/johnbellone/vault-cookbook/issues/57)
- Vault 0.5.3 update \(with test fixes, build-essential update\) [\#62](https://github.com/johnbellone/vault-cookbook/pull/62) ([axtl](https://github.com/axtl))
- Fix default value of "leases" attribute [\#60](https://github.com/johnbellone/vault-cookbook/pull/60) ([legal90](https://github.com/legal90))
- vault\_secret: Save lease ID to the nested attribute [\#56](https://github.com/johnbellone/vault-cookbook/pull/56) ([legal90](https://github.com/legal90))

## v2.2.0 (2016-04-19)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v2.1.1...v2.2.0)

- Specifying 'root' removes root login shell [\#53](https://github.com/johnbellone/vault-cookbook/issues/53)
- Configure consul backend in hashicorp-vault \> 1.5.x [\#48](https://github.com/johnbellone/vault-cookbook/issues/48)
- Prevent "vault" service to be restarted on update [\#52](https://github.com/johnbellone/vault-cookbook/pull/52) ([legal90](https://github.com/legal90))
- Use custom templates for "systemd" and "sysvinit" service providers [\#51](https://github.com/johnbellone/vault-cookbook/pull/51) ([legal90](https://github.com/legal90))
- Added a resource for reading secrets from Vault [\#49](https://github.com/johnbellone/vault-cookbook/pull/49) ([Ginja](https://github.com/Ginja))

## v2.1.1 (2016-03-17)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v2.1.0...v2.1.1)

- Fixed typo in vault\_config provider property [\#47](https://github.com/johnbellone/vault-cookbook/pull/47) ([Ginja](https://github.com/Ginja))

## v2.1.0 (2016-03-17)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v2.0.0...v2.1.0)

- Getting warning message in Chef run [\#46](https://github.com/johnbellone/vault-cookbook/issues/46)
- Fix binary installation for i386 architectures. [\#44](https://github.com/johnbellone/vault-cookbook/pull/44) ([johnbellone](https://github.com/johnbellone))

## v2.0.0 (2016-03-04)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.5.1...v2.0.0)

- etcd in not supported as backend secret storage [\#25](https://github.com/johnbellone/vault-cookbook/issues/25)
- tls\_disable attribute only accepts strings [\#40](https://github.com/johnbellone/vault-cookbook/issues/40)
- Error executing action `create` on resource 'vault\_config\[/home/vault/.vault.json\]' [\#39](https://github.com/johnbellone/vault-cookbook/issues/39)
- undefined method `delete' for nil:NilClass [\#34](https://github.com/johnbellone/vault-cookbook/issues/34)
- metadata updates [\#33](https://github.com/johnbellone/vault-cookbook/issues/33)
- No method chef\_vault\_item [\#24](https://github.com/johnbellone/vault-cookbook/issues/24)
- vault\_config.rb doesn't writes out telemetry section properly [\#6](https://github.com/johnbellone/vault-cookbook/issues/6)
- Fixed Install Issues [\#42](https://github.com/johnbellone/vault-cookbook/pull/42) ([Ginja](https://github.com/Ginja))
- Coerce tls\_disable attribute to a string. [\#41](https://github.com/johnbellone/vault-cookbook/pull/41) ([CodeGnome](https://github.com/CodeGnome))

## v1.5.1 (2016-02-18)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.5.0...v1.5.1)

- Add support for Vault 0.5.0 [\#36](https://github.com/johnbellone/vault-cookbook/pull/36) ([legal90](https://github.com/legal90))

## v1.5.0 (2016-02-03)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.4.0...v1.5.0)

- \['vault'\]\['config'\]\['manage\_certificate'\] = false does not end up getting set on vault\_config resource [\#31](https://github.com/johnbellone/vault-cookbook/issues/31)
- Vault 0.2.0 - Does not like tls\_disable entered as empty string [\#8](https://github.com/johnbellone/vault-cookbook/issues/8)
- Multiple fixes [\#35](https://github.com/johnbellone/vault-cookbook/pull/35) ([sh9189](https://github.com/sh9189))
- Fix tls\_disable with vault 0.4.0 [\#30](https://github.com/johnbellone/vault-cookbook/pull/30) ([shaneramey](https://github.com/shaneramey))
- support vault 0.4.0 [\#28](https://github.com/johnbellone/vault-cookbook/pull/28) ([shaneramey](https://github.com/shaneramey))
- Modify attributes to support vault 0.3.1 [\#26](https://github.com/johnbellone/vault-cookbook/pull/26) ([NickLaMuro](https://github.com/NickLaMuro))

## v1.4.0 (2015-09-28)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.3.1...v1.4.0)

- Fails to start vault server on CentOS 7.1 [\#22](https://github.com/johnbellone/vault-cookbook/issues/22)
- Add note into documentation about chef-vault coobook version [\#21](https://github.com/johnbellone/vault-cookbook/issues/21)
- Spec test issue for vault\_config: Chef::Provider does not implement \#chef\_vault\_item [\#11](https://github.com/johnbellone/vault-cookbook/issues/11)
- Move test data bag item to standard location [\#19](https://github.com/johnbellone/vault-cookbook/pull/19) ([jeffbyrnes](https://github.com/jeffbyrnes))
- Clean up spec tests & switch to using Rake [\#18](https://github.com/johnbellone/vault-cookbook/pull/18) ([jeffbyrnes](https://github.com/jeffbyrnes))
- Pin chef-vault to specific ref [\#16](https://github.com/johnbellone/vault-cookbook/pull/16) ([jeffbyrnes](https://github.com/jeffbyrnes))
- Update Serverspec assertions as per Rspec 3 [\#15](https://github.com/johnbellone/vault-cookbook/pull/15) ([jeffbyrnes](https://github.com/jeffbyrnes))
- Make the TLS certificate management optional [\#13](https://github.com/johnbellone/vault-cookbook/pull/13) ([jeffbyrnes](https://github.com/jeffbyrnes))
- Update tests for SSL cert/key to match attributes [\#12](https://github.com/johnbellone/vault-cookbook/pull/12) ([jeffbyrnes](https://github.com/jeffbyrnes))

## v1.3.1 (2015-08-13)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.3.0...v1.3.1)

## v1.3.0 (2015-08-13)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.2.1...v1.3.0)

## v1.2.1 (2015-08-07)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.2.0...v1.2.1)

## v1.2.0 (2015-08-04)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.1.0...v1.2.0)

- Vault service fails to start [\#5](https://github.com/johnbellone/vault-cookbook/issues/5)
- Upgrading to Vault 0.2.0 [\#2](https://github.com/johnbellone/vault-cookbook/issues/2)
- fixing default attributes based on HWRP [\#3](https://github.com/johnbellone/vault-cookbook/pull/3) ([zarry](https://github.com/zarry))

## v1.1.0 (2015-06-16)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.0.1...v1.1.0)

## v1.0.1 (2015-06-15)

[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.0.0...v1.0.1)

## v1.0.0 (2015-06-12)

\- -This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)-\- -This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)-
