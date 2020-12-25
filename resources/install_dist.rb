include Vault::Cookbook::Helpers

property :vault_user, String,
         default: 'vault',
         description: 'Set to override default vault user. Defaults to vault.'

property :vault_group, String,
         default: 'vault',
         description: 'Set to override default vault group. Defaults to vault.'

property :version, String,
         name_property: true,
         description: 'Set to specify the version of Vault to install. Defaults to 1.4.1.'

property :url, String,
         default: lazy { vault_source(version) },
         description: 'Set to specify the source path to the zip file. Defaults to Vault public download site.'

property :checksum, String,
         description: 'Set to specify the SHA256 checksum for the installation zip package.'

action :install do
  group 'vault'

  user new_resource.vault_user do
    comment 'vault user'
    group new_resource.vault_group
    shell '/bin/false'
    system true
    action :create
  end

  package %w(unzip rsync) do
    action :install
  end

  package %w(libcap2-bin) do
    action :install
    only_if { platform_family?('debian') }
  end

  ark 'vault' do
    url new_resource.url
    version new_resource.version
    checksum new_resource.checksum unless new_resource.checksum.nil?
    prefix_root '/opt/vault'
    has_binaries ['vault']
    prefix_bin '/usr/local/bin'
    strip_components 0
    action :install
  end

  execute 'setcap cap_ipc_lock' do
    command 'setcap cap_ipc_lock=+ep $(readlink -f /usr/local/bin/vault)'
    not_if 'setcap -v cap_ipc_lock+ep $(readlink -f /usr/local/bin/vault)'
    action :run
  end
end

action :remove do
  link '/usr/local/bin/vault' do
    action :delete
    only_if 'test -L /usr/local/bin/vault'
  end

  directory "/opt/vault/vault-#{new_resource.version}" do
    action :delete
  end
end

action_class do
  include Vault::Cookbook::Helpers
end
