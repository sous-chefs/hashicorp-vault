# Change Log

## [v2.1.0](https://github.com/johnbellone/vault-cookbook/tree/v2.1.0) (2016-03-17)
[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v2.0.0...v2.1.0)

**Closed issues:**

- Getting warning message in Chef run [\#46](https://github.com/johnbellone/vault-cookbook/issues/46)

**Merged pull requests:**

- Fix binary installation for i386 architectures. [\#44](https://github.com/johnbellone/vault-cookbook/pull/44) ([johnbellone](https://github.com/johnbellone))

## [v2.0.0](https://github.com/johnbellone/vault-cookbook/tree/v2.0.0) (2016-03-04)
[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.5.1...v2.0.0)

**Implemented enhancements:**

- etcd in not supported as backend secret storage [\#25](https://github.com/johnbellone/vault-cookbook/issues/25)

**Closed issues:**

- tls\_disable attribute only accepts strings [\#40](https://github.com/johnbellone/vault-cookbook/issues/40)
- Error executing action `create` on resource 'vault\_config\[/home/vault/.vault.json\]' [\#39](https://github.com/johnbellone/vault-cookbook/issues/39)
- undefined method `delete' for nil:NilClass [\#34](https://github.com/johnbellone/vault-cookbook/issues/34)
- metadata updates [\#33](https://github.com/johnbellone/vault-cookbook/issues/33)
- No method chef\_vault\_item [\#24](https://github.com/johnbellone/vault-cookbook/issues/24)
- vault\_config.rb doesn't writes out telemetry section properly [\#6](https://github.com/johnbellone/vault-cookbook/issues/6)

**Merged pull requests:**

- Fixed Install Issues [\#42](https://github.com/johnbellone/vault-cookbook/pull/42) ([Ginja](https://github.com/Ginja))
- Coerce tls\_disable attribute to a string. [\#41](https://github.com/johnbellone/vault-cookbook/pull/41) ([CodeGnome](https://github.com/CodeGnome))

## [v1.5.1](https://github.com/johnbellone/vault-cookbook/tree/v1.5.1) (2016-02-18)
[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.5.0...v1.5.1)

**Merged pull requests:**

- Add support for Vault 0.5.0 [\#36](https://github.com/johnbellone/vault-cookbook/pull/36) ([legal90](https://github.com/legal90))

## [v1.5.0](https://github.com/johnbellone/vault-cookbook/tree/v1.5.0) (2016-02-03)
[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.4.0...v1.5.0)

**Closed issues:**

- \['vault'\]\['config'\]\['manage\_certificate'\] = false does not end up getting set on vault\_config resource [\#31](https://github.com/johnbellone/vault-cookbook/issues/31)
- Vault 0.2.0 - Does not like tls\_disable entered as empty string [\#8](https://github.com/johnbellone/vault-cookbook/issues/8)

**Merged pull requests:**

- Multiple fixes [\#35](https://github.com/johnbellone/vault-cookbook/pull/35) ([sh9189](https://github.com/sh9189))
- Fix tls\_disable with vault 0.4.0 [\#30](https://github.com/johnbellone/vault-cookbook/pull/30) ([shaneramey](https://github.com/shaneramey))
- support vault 0.4.0 [\#28](https://github.com/johnbellone/vault-cookbook/pull/28) ([shaneramey](https://github.com/shaneramey))
- Modify attributes to support vault 0.3.1 [\#26](https://github.com/johnbellone/vault-cookbook/pull/26) ([NickLaMuro](https://github.com/NickLaMuro))

## [v1.4.0](https://github.com/johnbellone/vault-cookbook/tree/v1.4.0) (2015-09-28)
[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.3.1...v1.4.0)

**Closed issues:**

- Fails to start vault server on CentOS 7.1 [\#22](https://github.com/johnbellone/vault-cookbook/issues/22)
- Add note into documentation about chef-vault coobook version [\#21](https://github.com/johnbellone/vault-cookbook/issues/21)
- Spec test issue for vault\_config: Chef::Provider does not implement \#chef\_vault\_item [\#11](https://github.com/johnbellone/vault-cookbook/issues/11)

**Merged pull requests:**

- Move test data bag item to standard location [\#19](https://github.com/johnbellone/vault-cookbook/pull/19) ([jeffbyrnes](https://github.com/jeffbyrnes))
- Clean up spec tests & switch to using Rake [\#18](https://github.com/johnbellone/vault-cookbook/pull/18) ([jeffbyrnes](https://github.com/jeffbyrnes))
- Pin chef-vault to specific ref [\#16](https://github.com/johnbellone/vault-cookbook/pull/16) ([jeffbyrnes](https://github.com/jeffbyrnes))
- Update Serverspec assertions as per Rspec 3 [\#15](https://github.com/johnbellone/vault-cookbook/pull/15) ([jeffbyrnes](https://github.com/jeffbyrnes))
- Make the TLS certificate management optional [\#13](https://github.com/johnbellone/vault-cookbook/pull/13) ([jeffbyrnes](https://github.com/jeffbyrnes))
- Update tests for SSL cert/key to match attributes [\#12](https://github.com/johnbellone/vault-cookbook/pull/12) ([jeffbyrnes](https://github.com/jeffbyrnes))

## [v1.3.1](https://github.com/johnbellone/vault-cookbook/tree/v1.3.1) (2015-08-13)
[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.3.0...v1.3.1)

## [v1.3.0](https://github.com/johnbellone/vault-cookbook/tree/v1.3.0) (2015-08-13)
[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.2.1...v1.3.0)

## [v1.2.1](https://github.com/johnbellone/vault-cookbook/tree/v1.2.1) (2015-08-07)
[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.2.0...v1.2.1)

## [v1.2.0](https://github.com/johnbellone/vault-cookbook/tree/v1.2.0) (2015-08-04)
[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.1.0...v1.2.0)

**Closed issues:**

- Vault service fails to start [\#5](https://github.com/johnbellone/vault-cookbook/issues/5)
- Upgrading to Vault 0.2.0 [\#2](https://github.com/johnbellone/vault-cookbook/issues/2)

**Merged pull requests:**

- fixing default attributes based on HWRP [\#3](https://github.com/johnbellone/vault-cookbook/pull/3) ([zarry](https://github.com/zarry))

## [v1.1.0](https://github.com/johnbellone/vault-cookbook/tree/v1.1.0) (2015-06-16)
[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.0.1...v1.1.0)

## [v1.0.1](https://github.com/johnbellone/vault-cookbook/tree/v1.0.1) (2015-06-15)
[Full Changelog](https://github.com/johnbellone/vault-cookbook/compare/v1.0.0...v1.0.1)

## [v1.0.0](https://github.com/johnbellone/vault-cookbook/tree/v1.0.0) (2015-06-12)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*