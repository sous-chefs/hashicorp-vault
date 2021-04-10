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

use '_config_hcl_base'
use '_config_hcl_item'

action_class do
  include Vault::Cookbook::Helpers
  include Vault::Cookbook::ResourceHelpers
end

load_current_value do
  current_value_does_not_exist! unless ::File.exist?(config_file)

  type vault_hcl_config_current_load(config_file).fetch(vault_hcl_config_type, {}).keys.first
  options vault_hcl_config_current_load(config_file).dig(vault_hcl_config_type, type)
end

action :create do
  converge_if_changed { vault_hcl_resource_template_add }
end

action :delete do
  edit_resource(:file, new_resource.config_file).action(:delete) if ::File.exist?(new_resource.config_file)
end
