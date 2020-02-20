include Vault::Cookbook::Helpers

property :vault_user, String,
         default: 'vault',
         description: 'Set to override default vault user. Defaults to vault.'

property :vault_group, String,
         default: 'vault',
         description: 'Set to override default vault group. Defaults to vault.'

property :config_location, String,
         name_property: true,
         description: 'Set to override default config location. Defaults to /etc/vault/vault.json'

action :create do
  directory '/var/run/vault' do
    owner new_resource.vault_user
    group new_resource.vault_group
    mode '0740'
    action :create
  end

  # REVIEW: Whether to use symlink version.
  systemd_unit new_resource.name do
    content <<-EOU.gsub(/^\s+/, '')
    [Unit]
    Description=Runs Hashicorp Vault
    Wants=network.target
    After=network.target

    [Service]
    Environment=\"PATH=/usr/local/bin:/usr/bin:bin"
    RuntimeDirectory=vault
    RuntimeDirectoryMode=0740
    ExecStart=/usr/local/bin/vault server -config=#{new_resource.config_location} -log-level=info
    ExecReload=/bin/kill -HUP $MAINPID
    KillSignal=TERM
    User= #{new_resource.vault_user}
    WorkingDirectory=/var/run/vault

    [Install]
    WantedBy=multi-user.target
    EOU

    action [:create, :enable]
  end
end

# REVIEW: Is this overkill?
action :start do
  service 'vault' do
    action :start
  end
end

action :remove do
  systemd_unit new_resource.name do
    action [:stop, :delete]
  end

  directory '/var/run/vault' do
    action :delete
  end
end

action_class do
  include Vault::Cookbook::Helpers
end
