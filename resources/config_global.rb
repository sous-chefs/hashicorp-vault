#
# Cookbook:: hashicorp-vault
# Resource:: config_global
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
          default: lazy { default_vault_config_file(:hcl) },
          description: 'Set to override vault configuration file. Defaults to /etc/vault.d/vault.hcl'

property :cookbook, String,
          default: 'hashicorp-vault',
          description: 'Template source cookbook for the HCL configuration type.'

property :template, String,
          default: 'vault/hcl.erb',
          description: 'Template source file for the HCL configuration type.'

property :sensitive, [true, false],
         default: true,
         description: 'Ensure that sensitive resource data is not output by Chef Infra Client.'

property :global, Hash,
          default: lazy { default_vault_config_hcl(:global) },
          description: 'Vault global configuration.'

property :cache, Hash,
          default: lazy { default_vault_config_hcl(:cache) },
          description: 'Vault global cache configuration.'

property :sentinel, Hash,
          default: lazy { default_vault_config_hcl(:sentinel) },
          description: 'Vault global sentinel configuration.'

property :telemetry, Hash,
          default: lazy { default_vault_config_hcl(:telemetry) },
          description: 'Vault global telemetry configuration.'

property :vault, Hash,
          default: lazy { default_vault_config_hcl(:vault) },
          description: 'Vault global vault configuration.'

action_class do
  include Vault::Cookbook::Helpers
  include Vault::Cookbook::ResourceHelpers

  VAULT_GLOBAL_PROPERTIES = %i(global cache sentinel telemetry vault).freeze
end

action :create do
  vault_hcl_config_resource_init

  VAULT_GLOBAL_PROPERTIES.each { |property| vault_hcl_config_resource.variables[property] = new_resource.send(property) }
end

action :delete do
  vault_hcl_config_resource_init

  VAULT_GLOBAL_PROPERTIES.each do |property|
    new_resource.send(property).each { |k, _| vault_hcl_config_resource.variables[property].delete(k) }
  end
end
