#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
default['vault']['service_name'] = 'vault'
default['vault']['service_user'] = 'vault'
default['vault']['service_group'] = 'vault'

default['vault']['bag_name'] = 'secrets'
default['vault']['bag_item'] = 'vault'

default['vault']['version'] = '0.4.0'

default['vault']['config']['path'] = '/home/vault/.vault.json'
default['vault']['config']['address'] = '127.0.0.1:8200'
default['vault']['config']['manage_certificate'] = true
default['vault']['config']['tls_cert_file'] = '/etc/vault/ssl/certs/vault.crt'
default['vault']['config']['tls_key_file'] = '/etc/vault/ssl/private/vault.key'

default['vault']['service']['package_name'] = 'vault'
default['vault']['service']['install_method'] = 'binary'
default['vault']['service']['binary_url'] = "https://releases.hashicorp.com/vault/%{version}/vault_%{filename}.zip" # rubocop:disable Style/StringLiterals
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
  '0.2.0_windows_amd64' => '1905354ad1652a8bd33c23f546b9df0e22b2c20a157c28545ff20b3cd74ea9e9',
  '0.3.0_darwin_386' => 'c0410040c6b26bdcdb619ab5b32c195b92c968dccb7d9c9aa96127a5614ad0f6',
  '0.3.0_darwin_amd64' => 'f6c7a30671a90df09d39197262e019a7dd7ad36a68d2f5895080b899aa81fc58',
  '0.3.0_linux_386' => '3f25189efd210d0fcbcaf4796389d7cf04b86c670a68909adef41d75a52b117f',
  '0.3.0_linux_amd64' => '30b8953e98059d1e8d97f6a164aa574a346a58caf9c5c74a911056f42fbef4d5',
  '0.3.0_linux_arm' => 'c57623ee3ba311451c5b8cc7cc1893e06ed38d19279390de784bf833d63e0bdb',
  '0.3.0_windows_386' => '6151401f56a09188e958d3af8d99d58e6ea2984117b13998d57c245faed936e3',
  '0.3.0_windows_amd64' => '012f79bb190817075d15a714e92fdb6fa26c638c46c4e9587143f5f69a2f3e0e',
  '0.3.1_darwin_386' => '4ff4ef6e0c0507a09be569c72e49fe4b013acc1a3fa8eedae2e267f7f39cdf08',
  '0.3.1_darwin_amd64' => '0a67d3ee6743c96e6cb96484b208555a2ea6f19fd7b51057410fd6f4a49aafad',
  '0.3.1_linux_386' => '2e09df75efed43c1f29c1be020ad49d712a6eb5b2413961aea7d5ed47b982f36',
  '0.3.1_linux_amd64' => '4005f0ae1bd88ad2676859430209129ed13bc3ade6b64fcf40cc3a6d4d9469e7',
  '0.3.1_linux_arm' => '920e5ea35212d6e885be93ef66d6a6045357f6f5f0a3415255339674544d33be',
  '0.3.1_windows_386' => '021834c98bb42e3c902c642326a637184c6519e2d40208e0976d885867042da2',
  '0.3.1_windows_amd64' => '972c86317c4389db5edd3fadfebd3cd4c9a94c5bc6045dd3fec47d9cb4fe0491',
  '0.4.0_darwin_386' => 'dad7401d0692e531713d8c0b23e77dea1f7df9cb1c689e3e2dea06b607100f30',
  '0.4.0_darwin_amd64' => 'be81a99496c9949d261cf119cd58ee617088fffd9feaa045605e00063c490bb6',
  '0.4.0_linux_386' => '595af129648b0ea1c0810e6c976d298a16b4f2d348e1cf31ebac7800ebf66c0b',
  '0.4.0_linux_amd64' => 'f56933cb7a445db89f8832016a862ca39b3e63dedb05709251e59d6bb40c56e8',
  '0.4.0_linux_arm' => '9883ff7d8cb858ce7163f75f3b6157aaa06d4b1a612d7fa9956869e73cc13bd4',
  '0.4.0_windows_386' => 'd2d8e9440f87221b6b5b887e0929ccfd6ba827a37755f7b10a40188e580040af',
  '0.4.0_windows_amd64' => '6e91a7d8817a2fc03859dfeda40f4175593b273d3b2564d3e59e9405c1d8b260'
}
