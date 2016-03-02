#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
default['vault']['service_name'] = 'vault'
default['vault']['service_user'] = 'vault'
default['vault']['service_group'] = 'vault'

default['vault']['bag_name'] = 'secrets'
default['vault']['bag_item'] = 'vault'

default['vault']['version'] = '0.5.0'

default['vault']['config']['path'] = '/etc/vault/vault.json'
default['vault']['config']['address'] = '127.0.0.1:8200'
default['vault']['config']['manage_certificate'] = false
default['vault']['config']['tls_cert_file'] = '/etc/vault/ssl/certs/vault.crt'
default['vault']['config']['tls_key_file'] = '/etc/vault/ssl/private/vault.key'
