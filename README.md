# vault-cookbook
![Build Status](https://img.shields.io/travis/coderanger/chef-collectd.svg)](https://travis-ci.org/johnbellone/vault-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/poise.svg)](https://supermarket.chef.io/cookbooks/hashicorp-vault)
[![Coverage](https://img.shields.io/codecov/c/github/coderanger/chef-collectd.svg)](https://codecov.io/github/johnbellone/vault-cookbook)
llectd)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

[Application cookbook][0] for installing and configuring [Hashicorp Vault][1].

## Usage
### Attributes
| Key | Type | Description | Default |
| --- | ---- | ----------- | ------- |
| node['vault']['version'] | String | Version of Vault to install. | 0.1.2 |
| node['vault']['install_method'] | Symbol | Install method for Vault. | :binary |
| node['vault']['package_name'] | String | Name of package to install. | vault |
| node['vault']['binary_url'] | String | URL to download Vault binary. | [See attributes/default.rb](attributes/default.rb) |
| node['vault']['source_repository'] | String | URL for source repository. | [See attributes/default.rb](attributes/default.rb) |
| node['vault']['service_name'] | String | Name of the Vault system service. | vault |
| node['vault']['service_user'] | String | Name of the Vault service user.| vault |
| node['vault']['service_group'] | String | Name of the Vault service group.| vault |

### Resources

[0]: http://blog.vialstudios.com/the-environment-cookbook-pattern/#thelibrarycookbook
[1]: https://www.vaultproject.io
