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

vault_config node['vault']['config_path'] do
  owner node['vault']['service_user']
  group node['vault']['service_group']
  config node['vault']['config']
  notifies :restart, "vault_service[#{node['vault']['service_name']}]", :delayed
end

service = vault_service node['vault']['service_name'] do |r|
  user node['vault']['service_user']
  group node['vault']['service_group']
  version node['vault']['version']

  node['vault']['service'].each_pair { |k, v| r.send(k, v) }
  action [:enable, :start]
end

vault_binary = File.join(service.install_path, 'vault', 'current', 'vault')
execute "setcap cap_ipc_lock=+ep #{vault_binary}" do
  not_if { node['platform_family'] == 'windows' }
  not_if { node['platform_family'] == 'mac_os_x' }
  not_if { node['vault']['config']['disable_mlock'] }
  not_if "getcap #{vault_binary}|grep cap_ipc_lock+ep"
end
