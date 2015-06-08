#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
default['vault']['service_name'] = 'vault'
default['vault']['service_user'] = 'vault'
default['vault']['service_group'] = 'vault'

default['vault']['version'] = '0.1.2'
default['vault']['remote_url'] = "https://dl.bintray.com/mitchellh/vault/vault_%(version).zip"
default['vault']['remote_checksum'] = {
}
