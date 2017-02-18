#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
default['hashicorp-vault']['gems'] = {
  vault: '0.4.0',
}

default['hashicorp-vault']['service_name'] = 'vault'
default['hashicorp-vault']['service_user'] = 'vault'
default['hashicorp-vault']['service_group'] = 'vault'

default['hashicorp-vault']['version'] = '0.6.5'

default['hashicorp-vault']['config']['path'] = '/etc/vault/vault.json'
default['hashicorp-vault']['config']['address'] = '127.0.0.1:8200'
default['hashicorp-vault']['config']['tls_cert_file'] = '/etc/vault/ssl/certs/vault.crt'
default['hashicorp-vault']['config']['tls_key_file'] = '/etc/vault/ssl/private/vault.key'
