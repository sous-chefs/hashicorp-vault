# hashicorp-vault cookbook
[![Build Status](https://travis-ci.org/johnbellone/vault-cookbook.svg?branch=master)](https://travis-ci.org/johnbellone/vault-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/hashicorp-vault.svg)](https://supermarket.chef.io/cookbooks/hashicorp-vault)
[![Coverage](https://img.shields.io/codecov/c/github/johnbellone/vault-cookbook.svg)](https://codecov.io/github/johnbellone/vault-cookbook)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

[Application cookbook][0] for installing and configuring [Hashicorp Vault][1].

Vault is a tool, which when used properly, manages secure manage to
secrets for your infrastructure.

## Platform Support
The following platforms have been certified with integration tests
using Test Kitchen:

- CentOS (RHEL) 5.11, 6.8, 7.2
- Ubuntu 12.04, 14.04, 16.04

## Basic Usage
This cookbook was designed from the ground up to make it dead simple
to install and configure the [Vault daemon][1] as a system service
using Chef. It highlights several of our best practices for developing
reusable infrastructure at Bloomberg.

This cookbook provides three sets of
[node attributes](attributes/default.rb) which can be used to fine
tune the default recipe which installs and configures Vault. The
values from these node attributes are fed directly into the custom
resources.

This cookbook can be added to the run list of all of the nodes that
you want to be part of the cluster. But the best way to use this is in
a [wrapper cookbook][2] which sets up a backend, and potentially even
TLS certificates. We provide an example [Vault Cluster cookbook][3]
which uses our [Consul cookbook][4] for a highly-available
storage solution.

[0]: http://blog.vialstudios.com/the-environment-cookbook-pattern/#thelibrarycookbook
[1]: https://www.vaultproject.io
[2]: http://blog.vialstudios.com/the-environment-cookbook-pattern/#thewrappercookbook
[3]: https://github.com/johnbellone/vault-cluster-cookbook
[4]: https://github.com/johnbellone/consul-cookbook
[5]: https://github.com/chef-cookbooks/chef-vault
