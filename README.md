# vault-cookbook
[![Build Status](https://img.shields.io/travis/johnbellone/vault-cookbook.svg)](https://travis-ci.org/johnbellone/vault-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/hashicorp-vault.svg)](https://supermarket.chef.io/cookbooks/hashicorp-vault)
[![Coverage](https://img.shields.io/codecov/c/github/johnbellone/vault-cookbook.svg)](https://codecov.io/github/johnbellone/vault-cookbook)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

[Application cookbook][0] for installing and configuring [Hashicorp Vault][1].

Vault is a tool, which when used properly, manages secure manage to
secrets for your infrastructure.

## Basic Usage
This cookbook was designed from the ground up to make it dead simple
to install and configure a Vault cluster using Chef. It also highlights
several of our best practices for developing reusable infrastructure
at Bloomberg.

This cookbook provides [node attributes](attributes/default.rb) which
can be used to fine tune the default recipe which installs and
configures Kafka. The values from the node attributes are passed
directly into the configuration and service resources.

Out of the box the following platforms are certified to work and
are tested using our [Test Kitchen][8] configuration. Additional platforms
_may_ work, but your mileage may vary.
- CentOS (RHEL) 6.6, 7.1
- Ubuntu 12.04, 14.04

The correct way to use this cookbook is to create a
[wrapper cookbook][2] which configures all the members of the Vault
cluster. We provide an example [Vault Cluster cookbook][3] which
utilizes our [Consul cookbook][4] for a highly-available storage
solution for the cluster.

### Chef Vault cookbook
It is very important to note that this cookbook depends on [Chef Vault cookbook][5] for
managing SSL certificates.

[0]: http://blog.vialstudios.com/the-environment-cookbook-pattern/#thelibrarycookbook
[1]: https://www.vaultproject.io
[2]: http://blog.vialstudios.com/the-environment-cookbook-pattern/#thewrappercookbook
[3]: https://github.com/johnbellone/vault-cluster-cookbook
[4]: https://github.com/johnbellone/consul-cookbook
[5]: https://github.com/chef-cookbooks/chef-vault
