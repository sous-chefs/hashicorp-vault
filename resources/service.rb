include Vault::Cookbook::Helpers

property :service_name, String,
          coerce: proc { |p| "#{p}.service" },
          default: lazy { default_vault_service_name },
          description: 'Set to override service name. Defaults to vault.'

property :systemd_unit_content, [String, Hash],
          default: lazy { default_vault_unit_content },
          description: 'Override the systemd unit file contents'

property :vault_user, String,
          default: lazy { default_vault_user },
          description: 'Set to override default vault user. Defaults to vault.'

property :vault_group, String,
          default: lazy { default_vault_group },
          description: 'Set to override default vault group. Defaults to vault.'

property :config_file, String,
          default: lazy { default_vault_config_file },
          description: 'Set to override vault configuration file. Defaults to /etc/vault.d/vault.json'

action_class do
  def do_service_action(resource_action)
    with_run_context(:root) do
      edit_resource(:service, new_resource.service_name.delete_suffix('.service')) do
        action :nothing
        delayed_action resource_action
      end
    end
  end
end

action :create do
  systemd_unit new_resource.service_name do
    content new_resource.systemd_unit_content
    triggers_reload true

    action :create
  end
end

action :delete do
  do_service_action(:stop)

  systemd_unit new_resource.name do
    triggers_reload true

    action :delete
  end
end

%i(start stop restart reload enable disable).each do |service_action|
  action service_action do
    do_service_action(action)
  end
end
