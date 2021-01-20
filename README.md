# hashicorp-vault cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/hashicorp-vault.svg)](https://supermarket.chef.io/cookbooks/hashicorp-vault)
[![CI State](https://github.com/sous-chefs/vault/workflows/ci/badge.svg)](https://github.com/sous-chefs/vault/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Install and configure Hashicorp Vault in server and agent mode.

**Version 5.0.0 constitutes a major change and rewrite, please see [UPGRADING.md](./UPGRADING.md).**

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Platforms

The following platforms have been certified with integration tests
using Test Kitchen:

- Debian/Ubuntu
- RHEL/CentOS and derivatives
- Fedora and derivatives

## Requirements

- Chef 14+
- ark Community Cookbook (<https://supermarket.chef.io/cookbooks/ark>)

## Usage

It is recommended to create a project or organization specific [wrapper cookbook](https://www.chef.io/blog/2013/12/03/doing-wrapper-cookbooks-right/) and add the desired custom resources to the run list of a node. Depending on your environment, you may have multiple roles that use different recipes from this cookbook. Adjust any attributes as desired.

Example of a basic server configuration using Hashicorp HCL for configuration

```ruby
hashicorp_vault_install 'package' do
  action :upgrade
end

hashicorp_vault_config_global 'vault' do
  sensitive false
  telemetry(
    statsite_address: '127.0.0.1:8125',
    disable_hostname: true
  )

  notifies :restart, 'hashicorp_vault_service[vault]', :delayed

  action :create
end

hashicorp_vault_config_listener 'tcp' do
  options(
    'address' => '127.0.0.1:8200',
    'cluster_address' => '127.0.0.1:8201',
    'tls_cert_file' => '/opt/vault/tls/tls.crt',
    'tls_key_file' => '/opt/vault/tls/tls.key',
    'telemetry' => {
      'unauthenticated_metrics_access' => false,
    }
  )

  notifies :restart, 'hashicorp_vault_service[vault]', :delayed
end

hashicorp_vault_config_storage 'Test file storage' do
  type 'file'
  options(
    'path' => '/opt/vault/data'
  )

  notifies :restart, 'hashicorp_vault_service[vault]', :delayed
end

hashicorp_vault_service 'vault' do
  action %i(create enable start)
end

```

## External Documentation

- <https://www.vaultproject.io/docs/configuration>
- <https://www.vaultproject.io/docs/agent>

## Resources

- [hashicorp_vault_config_auto_auth](documentation/hashicorp_vault_config_auto_auth.md)
- [hashicorp_vault_config_entropy](documentation/hashicorp_vault_config_entropy.md)
- [hashicorp_vault_config_global](documentation/hashicorp_vault_config_global.md)
- [hashicorp_vault_config_listener](documentation/hashicorp_vault_config_listener.md)
- [hashicorp_vault_config_seal](documentation/hashicorp_vault_config_seal.md)
- [hashicorp_vault_config_service_registration](documentation/hashicorp_vault_config_service_registration.md)
- [hashicorp_vault_config_storage](documentation/hashicorp_vault_config_storage.md)
- [hashicorp_vault_config_template](documentation/hashicorp_vault_config_template.md)
- [hashicorp_vault_config](documentation/hashicorp_vault_config.md)
- [hashicorp_vault_install](documentation/hashicorp_vault_install.md)
- [hashicorp_vault_service](documentation/hashicorp_vault_service.md)

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
