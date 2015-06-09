#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#

config = vault_config File.join(node['vault']['config_path'], "#{node['vault']['service_name']}.json") do
  user node['vault']['service_user']
  group node['vault']['service_group']
  listen_address node['vault']['config']['listen_address']
  tls_disable node['vault']['config']['tls_disable']
  tls_cert_file node['vault']['config']['tls_cert_file']
  tls_key_file node['vault']['config']['tls_key_file']
  disable_mlock node['vault']['config']['disable_mlock']
  statsite_addr node['vault']['config']['statsite_addr']
  statsd_addr node['vault']['config']['statsd_addr']
  backend_type node['vault']['config']['backend_type']
  backend_options node['vault']['config']['backend_options']
end

vault_service node['vault']['service_name'] do
  version node['vault']['version']
  binary_url node['vault']['binary_url']
  source_repository node['vault']['source_repository']
  user node['vault']['service_user']
  group node['vault']['service_group']
  config_filename config.path
end
