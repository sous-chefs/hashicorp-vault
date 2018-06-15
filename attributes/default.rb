#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
default['hashicorp-vault']['service_name'] = 'vault'
default['hashicorp-vault']['service_user'] = 'vault'
default['hashicorp-vault']['service_group'] = 'vault'

default['hashicorp-vault']['bag_name'] = 'secrets'
default['hashicorp-vault']['bag_item'] = 'vault'

default['hashicorp-vault']['version'] = '0.5.1'

default['hashicorp-vault']['config']['path'] = '/etc/vault/vault.json'
default['hashicorp-vault']['config']['path_old'] = '/etc/vault/vault_old.json'
default['hashicorp-vault']['config']['address'] = '127.0.0.1:8200'
default['hashicorp-vault']['config']['tls_cert_file'] = '/etc/vault/ssl/certs/vault.crt'
default['hashicorp-vault']['config']['tls_key_file'] = '/etc/vault/ssl/private/vault.key'
