#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
poise_service_user node['vault']['service_user'] do
  group node['vault']['service_group']
end

config = vault_config node['vault']['config']['path'] do |r|
  owner node['vault']['service_user']
  group node['vault']['service_group']

  node['vault']['config'].each_pair { |k, v| r.send(k, v) }
  notifies :restart, "vault_service[#{node['vault']['service_name']}]", :delayed
end

vault_service node['vault']['service_name'] do |r|
  user node['vault']['service_user']
  group node['vault']['service_group']
  version node['vault']['version']
  config_path node['vault']['config']['path']
  disable_mlock config.disable_mlock

  node['vault']['service'].each_pair { |k, v| r.send(k, v) }
  action [:enable, :start]
end
