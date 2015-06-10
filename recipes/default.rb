#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#

config = node['vault']['config']
vault_config node['vault']['config_path'] do
  user node['vault']['service_user']
  group node['vault']['service_group']
  listen_address config['listen_address'] unless config['listen_address']
  tls_disable config['tls_disable'] unless config['tls_disable']
  tls_cert_file config['tls_cert_file'] unless config['tls_cert_file']
  tls_key_file config['tls_key_file'] unless config['tls_key_file']
  disable_mlock config['disable_mlock'] unless config['disable_mlock']
  statsite_addr config['statsite_addr'] unless config['statsite_addr']
  statsd_addr config['statsd_addr'] unless config['statsd_addr']
  backend_type config['backend_type'] unless config['backend_type']
  backend_options config['backend_options'] unless config['backend_options']
end

vault_service node['vault']['service_name'] do
  version node['vault']['version']
  package_name node['vault']['package_name']
  binary_url node['vault']['binary_url']
  source_repository node['vault']['source_repository']
  user node['vault']['service_user']
  group node['vault']['service_group']
  config_filename node['vault']['config_path']
end
