#
# Cookbook:: hashicorp-vault
# Resource:: config_listener
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

load_current_value do
  case vault_mode
  when :server
    current_value_does_not_exist! unless ::File.exist?(config_file)

    type vault_hcl_config_current_load(config_file).fetch(vault_hcl_config_type, {}).keys.first
    options vault_hcl_config_current_load(config_file).dig(vault_hcl_config_type, type)
  when :agent
    option_data = array_wrap(vault_hcl_config_current_load(config_file, vault_hcl_config_type)).select { |l| l.keys.first.eql?(type) }

    current_value_does_not_exist! if nil_or_empty?(option_data)
    raise Chef::Exceptions::InvalidResourceReference,
          "Filter matched #{option_data.count} listener configuration items but only should match one." if option_data.count > 1

    options option_data.first&.fetch(type)
  end
end

action :create do
  converge_if_changed { vault_hcl_resource_template_add }

  # We have to do this twice as the agent config file is accumulated and converge_if_changed won't always fire
  vault_hcl_resource_template_add if new_resource.vault_mode.eql?(:agent)
end

action :delete do
  case vault_mode
  when :server
    edit_resource(:file, new_resource.config_file).action(:delete) if ::File.exist?(new_resource.config_file)
  when :agent
    converge_by('Remove configuration from accumulator template') { vault_hcl_resource_template_remove } if vault_hcl_resource_template?
  end
end
