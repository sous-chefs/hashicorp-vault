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
default['vault']['remote_url'] = "https://dl.bintray.com/mitchellh/%(name)/%(name)_%(version).zip"
default['vault']['source_repository'] = 'https://github.com/hashicorp/vault'
default['vault']['checksums'] = {
  '0.1.2_darwin_386' => 'a4264b83432d8415fa8acbe60dafee7de119fba8b2472211861bd40a5e45381f',
  '0.1.2_darwin_amd64' => '42fe870cedb1152d1cb43e22c14a8786a30476764055de37a2fbf98e92cebe9b',
  '0.1.2_linux_386' => '20cf0fb7df3fb451bfd80ef7d14a7884d17e1a04b15ebdd3030d046d07d71b5a',
  '0.1.2_linux_amd64' => '12c28cf7d6b6052c24817072fb95d4cfa2a391b507c705e960faf11afb5ee6ad',
  '0.1.2_linux_arm' => '2f820f67e2126710c36870864a84eddc21b606c2646b675e7c8c3482be8f6f20',
  '0.1.2_windows_386' => '3baa8eb1334c8af0cf696e0a5510da9f68ec3ee3b45afaa9a3037ca2ea562338',
  '0.1.2_windows_amd64' => 'aff1455f69278662c76b4d9615fe10af98eb4d3c0ea60b8c334a2064f23deed1'
}
