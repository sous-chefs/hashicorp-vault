#
# Cookbook:: hashicorp-vault
# Resource:: install
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Vault::Cookbook::Helpers
include Vault::Cookbook::InstallHelpers

property :user, String,
          default: lazy { default_vault_user },
          description: 'Set to override default vault user. Defaults to vault.'

property :group, String,
          default: lazy { default_vault_group },
          description: 'Set to override default vault group. Defaults to vault.'

property :install_method, [String, Symbol],
          default: :repository,
          equal_to: [:repository, :ark],
          description: 'Set the method to install vault. Default to repo.'

property :packages, [String, Array],
          coerce: proc { |p| p.is_a?(Array) ? p : [ p ] },
          default: lazy { default_vault_packages },
          description: 'Vault packages to install.'

property :test_repo, [true, false],
          default: false,
          description: 'Enable hashicorp-testing repository'

property :version, String,
          description: 'Set to specify the version of Vault to install.'

property :url, String,
          default: lazy { vault_source(version) },
          description: 'Set to specify the source path to the zip file. Defaults to Vault public download site.'

property :checksum, String,
          description: 'Set to specify the SHA256 checksum for the installation zip package.'

action_class do
  include Vault::Cookbook::InstallHelpers

  def do_repository_action(resource_action)
    case node['platform_family']
    when 'rhel', 'fedora', 'amazon'
      yum_repository 'hashicorp' do
        description 'Hashicorp Stable - $basearch'
        baseurl "https://rpm.releases.hashicorp.com/#{vault_repo_platform}/$releasever/$basearch/stable"
        enabled true
        gpgcheck true
        gpgkey 'https://rpm.releases.hashicorp.com/gpg'

        action resource_action.eql?(:remove) ? :remove : :create
      end

      yum_repository 'hashicorp-test' do
        description 'Hashicorp Test - $basearch'
        baseurl "https://rpm.releases.hashicorp.com/#{vault_repo_platform}/$releasever/$basearch/test"
        enabled new_resource.test_repo
        gpgcheck true
        gpgkey 'https://rpm.releases.hashicorp.com/gpg'

        action resource_action.eql?(:remove) ? :remove : :create
      end
    when 'debian'
      apt_repository 'hashicorp' do
        uri 'https://apt.releases.hashicorp.com'
        distribution vault_repo_platform
        components ['main']
        arch 'amd64'
        key 'https://apt.releases.hashicorp.com/gpg'
        action resource_action.eql?(:remove) ? :remove : :add
      end
    else
      raise "Vault repository installation is unsupported for platform: #{platform}"
    end
  end

  def do_package_action(resource_action)
    package 'vault' do
      package_name new_resource.packages
      version new_resource.version

      notifies :run, 'execute[vault -autocomplete-install]', :immediately
      action resource_action
    end

    execute 'vault -autocomplete-install' do
      action :nothing
      only_if { ::File.exist?("#{Dir.home}/.bashrc") }
    end
  end
end

action :install do
  case new_resource.install_method
  when :repository
    do_repository_action(action)
    do_package_action(action)
  when :ark
    raise ArgumentError, 'ARK installation method requires version to be set' if new_resource.version.nil?

    group new_resource.group do
      comment 'Hashicorp Vault'
      system true

      action :create
    end

    user new_resource.user do
      comment 'Hashicorp Vault'
      group new_resource.group
      shell '/bin/false'
      system true

      action :create
    end

    package 'vault supporting packages' do
      package_name vault_supporting_packages

      action :install
    end

    ark 'vault' do
      url new_resource.url
      version new_resource.version
      checksum new_resource.checksum
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
end

action :upgrade do
  case new_resource.install_method
  when :repository
    do_repository_action(action)
    do_package_action(action)
  when :ark
    raise ArgumentError, 'Update action is not supported for :ark install method.'
  end
end

action :remove do
  case new_resource.install_method
  when :repository
    do_repository_action(action)
    do_package_action(action)
  when :ark
    link '/usr/local/bin/vault' do
      action :delete
    end

    directory "/opt/vault/vault-#{new_resource.version}" do
      recursive true

      action :delete
    end

    edit_resource(:user, new_resource.user).action(:delete)
    edit_resource(:group, new_resource.user).action(:delete)
  end
end
