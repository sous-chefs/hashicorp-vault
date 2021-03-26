hashicorp_vault_install 'package' do
  action :upgrade
end

hashicorp_vault_config 'vault' do
  sensitive false

  action :create
end

hashicorp_vault_service 'vault' do
  config_type :json
  action %i(create enable start)
  subscribes :restart, 'template[/etc/vault.d/vault.json]', :delayed
end
