#
# Cookbook:: hashicorp-vault
# Resource:: service_registration
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
include Vault::Cookbook::ResourceHelpers

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
         description: 'Ensure that sensitive resource data is not output by Chef Infra Client.',
          desired_state: false

property :type, [String, Symbol],
          coerce: proc { |p| p.to_s },
          description: 'Vault server service registration type.'

property :options, Hash,
          default: lazy { default_vault_config_hcl(:service_registration) },
          description: 'Vault server service registration configuration.'

property :description, String,
          desired_state: false,
          description: 'Unparsed description to add to the configuration file.'

action_class do
  include Vault::Cookbook::Helpers
  include Vault::Cookbook::ResourceHelpers
end

load_current_value do
  current_value_does_not_exist! if vault_hcl_config_current_load(config_file).dig(:service_registration, type).nil?
  options vault_hcl_config_current_load(config_file).dig(:service_registration, type)
end

action :create do
  vault_hcl_config_resource_init

  converge_if_changed {}

  vault_hcl_config_resource.variables[:service_registration] ||= []
  vault_hcl_config_resource.variables[:service_registration].push(vault_hcl_resource_data)
end

action :delete do
  vault_hcl_config_resource_init

  vault_hcl_config_resource.variables[:service_registration].delete(vault_hcl_resource_data)
end
