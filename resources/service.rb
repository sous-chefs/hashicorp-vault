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

property :max_open_files, Integer,
         default: 16384,
         description: 'Max open file descriptors than can be used by Vault'

property :vault_runtime, String,
         default: 'server',
         description: 'server or agent runtime'

property :log_level, String,
         default: 'info',
         description: 'Set the log level. Defaults to info.'

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
    ExecStart=/usr/local/bin/vault #{new_resource.vault_runtime} -config=#{new_resource.config_location} -log-level=#{new_resource.log_level}
    ExecReload=/bin/kill -HUP $MAINPID
    KillSignal=TERM
    LimitNOFILE=#{new_resource.max_open_files}
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
  service new_resource.name do
    action :start
  end
end

# Would not recommend this for server deployments but agent it makes sense.
action :restart do
  systemd_unit new_resource.name do
    action :restart
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
