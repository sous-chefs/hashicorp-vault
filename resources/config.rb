include Vault::Cookbook::Helpers

deprecated_property_alias 'config_location', 'config_file', 'The config_location property was renamed config_file in the 5.0 release of this cookbook. Please update your cookbooks to use the new property name.'

property :vault_user, String,
          default: lazy { default_vault_user },
          description: 'Set to override default vault user. Defaults to vault.'

property :vault_group, String,
          default: lazy { default_vault_group },
          description: 'Set to override default vault group. Defaults to vault.'

property :config_file, String,
          default: lazy { default_vault_config_file },
          description: 'Set to override vault configuration file. Defaults to /etc/vault.d/vault.json'

property :sensitive, [true, false],
         default: true,
         description: 'Ensure that sensitive resource data is not logged by Chef Infra Client.'

property :config, Hash,
          default: lazy { default_vault_config },
          description: 'Vault server configuration as a ruby Hash.'

action :create do
  edit_resource(:file, '/etc/vault.d/vault.hcl').action(:delete)

  chef_gem 'deepsort' do
    compile_time true
  end

  directory ::File.dirname(new_resource.config_file) do
    owner new_resource.vault_user
    group new_resource.vault_group
    mode '0750'

    action :create
  end

  require 'json'
  require 'deepsort'

  file new_resource.config_file do
    content JSON.pretty_generate(new_resource.config.map { |key, val| [key.to_s, val] }.to_h.deep_sort).concat("\n")

    owner new_resource.vault_user
    group new_resource.vault_group
    mode '0640'

    sensitive new_resource.sensitive

    action :create
  end
end

action :delete do
  edit_resource(:file, new_resource.config_file).action(:delete)
  edit_resource(:file, '/etc/vault.d/vault.hcl').action(:delete)
end
