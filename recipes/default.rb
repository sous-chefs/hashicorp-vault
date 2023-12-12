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
  if node['hashicorp-vault']['installation']
    node['hashicorp-vault']['installation'].each_pair { |k, v| r.send(k, v) }
  end
  r.send('enterprise', node['hashicorp-vault']['enterprise'])
  r.send('use_internal_repos', node['hashicorp-vault']['use_internal_repos'])
end

config = vault_config node['hashicorp-vault']['config']['path'] do |r|
  owner node['hashicorp-vault']['service_user']
  group node['hashicorp-vault']['service_group']

  if node['hashicorp-vault']['config']
    node['hashicorp-vault']['config'].each_pair do |k, v|
      if k == "license_path" and !node['hashicorp-vault']['license_content']
        next
      end
      r.send(k, v)
    end
  end

  notifies :reload, "vault_service[#{node['hashicorp-vault']['service_name']}]", :delayed
end

if node['hashicorp-vault']['license_content']
  file node['hashicorp-vault']['config']['license_path'] do
    content node['hashicorp-vault']['license_content']
    owner node['hashicorp-vault']['service_user']
    group node['hashicorp-vault']['service_group']
    sensitive true
    notifies :reload, "vault_service[#{node['hashicorp-vault']['service_name']}]", :delayed
  end
else
  node.default['hashicorp-vault']['config'].delete('license_path')
end

vault_service node['hashicorp-vault']['service_name'] do |r|
  user node['hashicorp-vault']['service_user']
  group node['hashicorp-vault']['service_group']
  config_path node['hashicorp-vault']['config']['path']
  disable_mlock config.disable_mlock
  program install.vault_program

  if node['hashicorp-vault']['service']
    node['hashicorp-vault']['service'].each_pair { |k, v| r.send(k, v) }
  end
  action [:enable, :start]
end
