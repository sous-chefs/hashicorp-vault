#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
include_recipe 'selinux::permissive'

poise_service_user node['vault']['service_user'] do
  group node['vault']['service_group']
end

vault_config node['vault']['config']['path'] do |r|
  user node['vault']['service_user']
  group node['vault']['service_group']

  node['vault']['config'].each_pair { |k, v| r.send(k, v) }
end

vault_service node['vault']['service_name'] do |r|
  user node['vault']['service_user']
  group node['vault']['service_group']
  version node['vault']['version']

  node['vault']['service'].each_pair { |k, v| r.send(k, v) }
  subscribes :reload, "vault_config[#{node['vault']['config']['path']}]", :immediately
  action [:enable, :start]
end
