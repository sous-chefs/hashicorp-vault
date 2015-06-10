#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
include_recipe 'selinux::disabled'

poise_service_user node['vault']['service_user'] do
  group node['vault']['service_group']
end

vault_config node['vault']['config_path'] do |resource|
  user node['vault']['service_user']
  group node['vault']['service_group']

  node['vault']['config'].each_pair { |k, v| resource.send(k, v) }
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
