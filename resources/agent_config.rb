property :vault_agent_config_path, String,
  name_property: true

property :vault_agent_pid_file, String,
  default: './pidfile'

property :vault_agent_exit_after_auth, [true, false],
  default: false

property :vault_agent_user, String,
  default: 'vault'

property :vault_agent_group, String,
  default: 'vault'

property :vault_address, String

property :vault_ca_cert, String

property :vault_ca_path, String

property :vault_client_cert, String

property :vault_client_key, String

property :vault_tls_skip_verify, String

property :vault_tls_server_name, String

property :auto_auth_method, String

property :auto_auth_method_mount_path, String

property :auto_auth_method_namespace, String

property :auto_auth_method_wrap_ttl, String

property :auto_auth_method_config, Hash

property :auto_auth_sink, Array,
  default: [{
    "type": 'file',
    "config": {
      "path": '/tmp/token',
    },
  }]

property :use_auto_auth_token, [true, false]

property :vault_agent_listener, Array,
  default: []

default_action :configure

action :configure do
  config = {
    'pid_file': new_resource.vault_agent_pid_file,
    'exit_after_auth': new_resource.vault_agent_exit_after_auth,
  }

  vault = {}
  vault['address'] = new_resource.vault_address unless new_resource.vault_address.nil?
  vault['ca_cert'] = new_resource.vault_ca_cert unless new_resource.vault_ca_cert.nil?
  vault['ca_path'] = new_resource.vault_ca_path unless new_resource.vault_ca_path.nil?
  vault['client_cert'] = new_resource.vault_client_cert unless new_resource.vault_client_cert.nil?
  vault['client_key'] = new_resource.vault_client_key unless new_resource.vault_client_key.nil?
  vault['tls_skip_verify'] = new_resource.vault_tls_skip_verify unless new_resource.vault_tls_skip_verify.nil?
  vault['tls_server_name'] = new_resource.vault_tls_server_name unless new_resource.vault_tls_server_name.nil?

  unless vault.empty?
    config['vault'] = vault
  end

  auto_auth = {
    'method': {
      'type': new_resource.auto_auth_method,
      'config': new_resource.auto_auth_method_config,
    },
    'sink': new_resource.auto_auth_sink,
  }

  auto_auth['mount_path'] = new_resource.auto_auth_method_mount_path unless new_resource.auto_auth_method_mount_path.nil?
  auto_auth['namespace'] = new_resource.auto_auth_method_namespace unless new_resource.auto_auth_method_namespace.nil?
  auto_auth['wrap_ttl'] = new_resource.auto_auth_method_wrap_ttl unless new_resource.auto_auth_method_wrap_ttl.nil?

  config['auto_auth'] = auto_auth

  unless new_resource.use_auto_auth_token.nil?
    config['cache'] = {
      'use_auto_auth_token': new_resource.use_auto_auth_token,
    }
  end

  unless new_resource.vault_agent_listener.empty?
    config['listener'] = new_resource.vault_agent_listener
  end

  template = VaultAgentTemplateCollection.instance.collection

  unless template.empty?
    config['template'] = template
  end

  directory ::File.dirname(new_resource.vault_agent_config_path) do
    user new_resource.vault_agent_user
    group new_resource.vault_agent_group
    mode '0740'
    action :create
  end

  file new_resource.vault_agent_config_path do
    content JSON.pretty_generate(config)
    user new_resource.vault_agent_user
    group new_resource.vault_agent_group
    mode '0740'
    action :create
  end
end

action :remove do
  file new_resource.vault_agent_config_path do
    action :delete
  end
end

action_class do
  require 'json'
end
