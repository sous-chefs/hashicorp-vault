hashicorp_vault_install 'package' do
  action :upgrade
end

hashicorp_vault_config '/etc/vault/vault.json' do
  sensitive false

  notifies :restart, 'hashicorp_vault_service[vault]', :delayed

  action :create
end

hashicorp_vault_service 'vault' do
  action %i(create enable start)
end
