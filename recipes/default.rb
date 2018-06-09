#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
poise_service_user node['hashicorp-vault']['service_user'] do
  group node['hashicorp-vault']['service_group']
  not_if { node['hashicorp-vault']['service_user'] == 'root' }
end

install = vault_installation node['hashicorp-vault']['version'] do |r|
  node['hashicorp-vault']['installation'].each_pair { |k, v| r.send(k, v) } if node['hashicorp-vault']['installation']
end

config = vault_config node['hashicorp-vault']['config']['path'] do |r|
  owner node['hashicorp-vault']['service_user']
  group node['hashicorp-vault']['service_group']

  node['hashicorp-vault']['config'].each_pair { |k, v| r.send(k, v) } if node['hashicorp-vault']['config']
  notifies :reload, "vault_service[#{node['hashicorp-vault']['service_name']}]", :delayed
end

vault_service node['hashicorp-vault']['service_name'] do |r|
  user node['hashicorp-vault']['service_user']
  group node['hashicorp-vault']['service_group']
  config_path node['hashicorp-vault']['config']['path']
  disable_mlock config.disable_mlock
  program install.vault_program

  node['hashicorp-vault']['service'].each_pair { |k, v| r.send(k, v) } if node['hashicorp-vault']['service']
  action %i(enable start)
end
