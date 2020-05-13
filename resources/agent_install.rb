include Vault::Cookbook::Helpers

property :vault_user, String,
         default: 'vault',
         description: 'Set to override default vault user. Defaults to vault.'

property :vault_group, String,
         default: 'vault',
         description: 'Set to override default vault group. Defaults to vault.'

property :config_location, String,
         default: '/etc/vault/agent.json',
         description: 'Set to override default config location. Defaults to /etc/vault/vault.json'

property :checksum, String,
         description: 'Set to specify the SHA256 checksum for the installation zip package.'

property :version, String,
         default: '1.4.1',
         description: 'Set to specify the version of Vault to install. Defaults to 1.4.1.'

property :url, String,
         default: lazy { vault_source(version) },
         description: 'Set to specify the source path to the zip file. Defaults to Vault public download site.'

# Config Options
property :max_open_files, Integer,
         default: 16384,
         description: 'Max open file descriptors than can be used by Vault.'

property :vault_agent_pid_file, String,
         default: './pidfile',
         description: 'Pidfile location. Defaults to ./pidfile.'

property :vault_agent_exit_after_auth, [true,false],
         default: false,
         description: 'Set to specify if the agent should exit after successful auth.'

property :vault_agent_user, String,
         default: 'vault',
         description: 'The user for the vault configuration and service.'

property :vault_agent_group, String,
         default: 'vault',
         description: 'Group for the vault configuration and service.'

property :vault_address, String,
         description: 'Address to the vault server to connect to.'

property :vault_ca_cert, String,
         description: 'The server CA Cert to trust'

property :vault_ca_path, String,
         description: 'Path to the CA cert'

property :vault_client_cert, String,
         description: 'The client cert path to file for authentcation'

property :vault_client_key, String,
         description: 'The client certs key path'

property :vault_tls_skip_verify, String,
         description: 'Set this to skip verifying the ssl cert. WARNING ENABLE THIS AT YOUR OWN RISK.'

property :vault_tls_server_name, String,
         description: 'Name to use as the SNI host when connecting via TLS.'

property :auto_auth_method, String,
         required: true,
         description: 'The type of the method to use, e.g. aws, gcp, azure, etc.'

property :auto_auth_method_mount_path, String,
         description: 'The mount path of the method. If not specified, defaults to a value of auth/<method type>.'

property :auto_auth_method_namespace, String,
         description: 'The default namespace path for the mount. If not specified, defaults to the root namespace.'

property :auto_auth_method_wrap_ttl, String,
         description: 'If specified, the written token will be response-wrapped by the agent. This is more secure than wrapping by sinks, but does not allow the agent to keep the token renewed or automatically reauthenticate when it expires.'

property :auto_auth_method_config, Hash,
         required: true,
         description: 'Configuration of the method itself.'

property :auto_auth_sink, Array,
  description: 'Set up one or more sinks to configure that agent to put tokens on the filesystem. Pass empty array if you dont want sinks.',
  default: [{
    "type": "file",
    "config": {
      "path": "/tmp/token"
    }
  }]

property :use_auto_auth_token, [true,false],
         description: 'If set, the requests made to agent without a Vault token will be forwarded to the Vault server with the auto-auth token attached.'

property :vault_agent_listener, Array,
  description: 'There can be one or more listener blocks at the top level.',
  default: []

action :install do

  hashicorp_vault_install_dist new_resource.version do
    vault_user new_resource.vault_user
    vault_group new_resource.vault_group
    checksum new_resource.checksum
    url new_resource.url
    action :install
  end

  hashicorp_vault_agent_config new_resource.config_location do
    vault_agent_pid_file new_resource.vault_agent_pid_file
    vault_agent_exit_after_auth new_resource.vault_agent_exit_after_auth
    vault_agent_user new_resource.vault_agent_user
    vault_agent_group new_resource.vault_agent_group
    vault_address new_resource.vault_address
    vault_ca_cert new_resource.vault_ca_cert
    vault_ca_path new_resource.vault_ca_path
    vault_client_cert new_resource.vault_client_cert
    vault_client_key new_resource.vault_client_key
    vault_tls_skip_verify new_resource.vault_tls_skip_verify
    vault_tls_server_name new_resource.vault_tls_server_name
    auto_auth_method new_resource.auto_auth_method
    auto_auth_method_mount_path new_resource.auto_auth_method_mount_path
    auto_auth_method_namespace new_resource.auto_auth_method_namespace
    auto_auth_method_wrap_ttl new_resource.auto_auth_method_wrap_ttl
    auto_auth_method_config new_resource.auto_auth_method_config
    auto_auth_sink new_resource.auto_auth_sink
    use_auto_auth_token new_resource.use_auto_auth_token
    vault_agent_listener new_resource.vault_agent_listener
    action :configure
    notifies :restart, 'hashicorp_vault_service[vault-agent.service]', :delayed
  end

  hashicorp_vault_service 'vault-agent.service' do
    vault_user new_resource.vault_user
    vault_group new_resource.vault_group
    config_location new_resource.config_location
    max_open_files new_resource.max_open_files
    vault_runtime 'agent'
    action [:create, :start]
  end
end

action :remove do
  hashicorp_vault_install_dist new_resource.version do
    action :remove
  end

  hashicorp_vault_agent_config new_resource.config_location do
    action :remove
  end

  hashicorp_vault_service 'vault-agent.service' do
    action :remove
  end
end

action_class do
  include Vault::Cookbook::Helpers
end
