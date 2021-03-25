#
# Cookbook:: hashicorp-vault
# Resource:: config
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

deprecated_property_alias 'config_location', 'config_file', 'The config_location property was renamed config_file in the 5.0 release of this cookbook. Please update your cookbooks to use the new property name.'

property :owner, String,
          default: lazy { default_vault_user },
          description: 'Set to override default vault user. Defaults to vault.'

property :group, String,
          default: lazy { default_vault_group },
          description: 'Set to override default vault group. Defaults to vault.'

property :mode, String,
          default: '0640',
          description: 'Set to override default vault config file mode. Defaults to 0600.'

property :config_file, String,
          default: lazy { default_vault_config_file(:json) },
          description: 'Set to override vault configuration file. Defaults to /etc/vault.d/vault.json'

property :cookbook, String,
          default: 'hashicorp-vault',
          description: 'Template source cookbook for the HCL configuration type.'

property :template, String,
          default: 'vault/hcl.erb',
          description: 'Template source file for the HCL configuration type.'

property :sensitive, [true, false],
          default: true,
          description: 'Ensure that sensitive resource data is not output by Chef Infra Client.',
          desired_state: false

property :config, Hash,
          default: lazy { default_vault_config_json },
          description: 'Vault server configuration as a ruby Hash.'

action_class do
  include Vault::Cookbook::Helpers
  include Vault::Cookbook::ResourceHelpers
end

action :create do
  directory ::File.dirname(new_resource.config_file) do
    owner new_resource.owner
    group new_resource.group
    mode '0750'

    action :create
  end

  chef_gem 'deepsort' do
    compile_time true
  end

  require 'json'
  require 'deepsort'

  file new_resource.config_file do
    content JSON.pretty_generate(new_resource.config.map { |key, val| [key.to_s, val] }.to_h.deep_sort).concat("\n")

    owner new_resource.owner
    group new_resource.group
    mode '0640'

    sensitive new_resource.sensitive

    action :create
  end
end

action :delete do
  edit_resource(:file, default_vault_config_file(config_type)).action(:delete)
end
