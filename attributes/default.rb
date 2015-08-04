#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
default['vault']['service_name'] = 'vault'
default['vault']['service_user'] = 'vault'
default['vault']['service_group'] = 'vault'

default['vault']['bag_name'] = 'secrets'
default['vault']['bag_item'] = 'vault'

default['vault']['version'] = '0.2.0'

default['vault']['config']['path'] = '/home/vault/.vault.json'
default['vault']['config']['address'] = '127.0.0.1:8200'
default['vault']['config']['tls_cert_file'] = '/etc/vault/ssl/certs/vault.crt'
default['vault']['config']['tls_key_file'] = '/etc/vault/ssl/private/vault.key'

default['vault']['service']['package_name'] = 'vault'
default['vault']['service']['install_method'] = 'binary'
default['vault']['service']['binary_url'] = "https://dl.bintray.com/mitchellh/vault/vault_%{version}.zip"  # rubocop:disable Style/StringLiterals
default['vault']['service']['source_url'] = 'https://github.com/hashicorp/vault'

default['vault']['checksums'] = {
  '0.1.2_darwin_386' => 'a4264b83432d8415fa8acbe60dafee7de119fba8b2472211861bd40a5e45381f',
  '0.1.2_darwin_amd64' => '42fe870cedb1152d1cb43e22c14a8786a30476764055de37a2fbf98e92cebe9b',
  '0.1.2_linux_386' => '20cf0fb7df3fb451bfd80ef7d14a7884d17e1a04b15ebdd3030d046d07d71b5a',
  '0.1.2_linux_amd64' => '12c28cf7d6b6052c24817072fb95d4cfa2a391b507c705e960faf11afb5ee6ad',
  '0.1.2_linux_arm' => '2f820f67e2126710c36870864a84eddc21b606c2646b675e7c8c3482be8f6f20',
  '0.1.2_windows_386' => '3baa8eb1334c8af0cf696e0a5510da9f68ec3ee3b45afaa9a3037ca2ea562338',
  '0.1.2_windows_amd64' => 'aff1455f69278662c76b4d9615fe10af98eb4d3c0ea60b8c334a2064f23deed1',
  '0.2.0_darwin_386' => '22f003b89dc34e6601f8d6cbcd79915bd010e0fa1a14fc291adc4905c5abcc00',
  '0.2.0_darwin_amd64' => '73dfa187a01fd4490b4c8a62a4316a4bd054538d4fd2df869415b0b00f37d654',
  '0.2.0_linux_386' => '9a4cb5470182e163eaa9d2526beb60c6a215c931c15452065f8caa4aa5821816',
  '0.2.0_linux_amd64' => 'b4b64fcea765ebfc7cdbae9cdd2c32bff130ca51f15b9cf47194f112fd5515cf',
  '0.2.0_linux_arm' => '883414010c26104889505aee69b461d1ca9378725dd2c7caafdcd1bba2d9c039',
  '0.2.0_windows_386' => '64aa7893678ae047c61021c97499feb20f924e51f65e9b7ea257cc17355182ec',
  '0.2.0_windows_amd64' => '1905354ad1652a8bd33c23f546b9df0e22b2c20a157c28545ff20b3cd74ea9e9'
}
