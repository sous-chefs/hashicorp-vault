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
include Vault::Cookbook::ResourceHelpers

use '_config_hcl_base'

property :global, Hash,
          default: lazy { default_vault_config_hcl(:global) },
          coerce: proc { |p| p.transform_keys(&:to_s) },
          description: 'Vault global configuration.'

property :cache, Hash,
          default: lazy { default_vault_config_hcl(:cache) },
          coerce: proc { |p| p.transform_keys(&:to_s) },
          description: 'Vault global cache configuration.'

property :sentinel, Hash,
          default: lazy { default_vault_config_hcl(:sentinel) },
          coerce: proc { |p| p.transform_keys(&:to_s) },
          description: 'Vault global sentinel configuration.'

property :telemetry, Hash,
          default: lazy { default_vault_config_hcl(:telemetry) },
          coerce: proc { |p| p.transform_keys(&:to_s) },
          description: 'Vault global telemetry configuration.'

property :vault, Hash,
          default: lazy { default_vault_config_hcl(:vault) },
          coerce: proc { |p| p.transform_keys(&:to_s) },
          description: 'Vault agent global vault configuration.'

action_class do
  include Vault::Cookbook::Helpers
  include Vault::Cookbook::ResourceHelpers
end

load_current_value do
  current_value_does_not_exist! unless ::File.exist?(config_file)
  Vault::Cookbook::ResourceHelpers::VAULT_GLOBAL_PROPERTIES.each { |property| send(property, vault_hcl_config_current_load(config_file).fetch(property, {})) }
end

action :create do
  converge_if_changed do
    Vault::Cookbook::ResourceHelpers::VAULT_GLOBAL_PROPERTIES.each { |property| vault_hcl_resource_template_add(property, new_resource.send(property)) }
  end

  # We have to do this twice as the agent config file is accumulated and converge_if_changed won't always fire
  if new_resource.vault_mode.eql?(:agent)
    Vault::Cookbook::ResourceHelpers::VAULT_GLOBAL_PROPERTIES.each { |property| vault_hcl_resource_template_add(property, new_resource.send(property)) }
  end
end

action :delete do
  edit_resource(:file, new_resource.config_file).action(:delete) if ::File.exist?(new_resource.config_file)
end
