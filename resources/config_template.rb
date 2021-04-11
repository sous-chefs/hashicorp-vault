#
# Cookbook:: hashicorp-vault
# Resource:: config_template
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

%w(base item).each { |t| use "partial/_config_hcl_#{t}" }

property :destination, String,
          coerce: proc { |p| p.to_s },
          name_property: true,
          description: 'Vault template destination file.'

property :vault_mode, [String, Symbol],
          coerce: proc { |p| p.to_sym },
          equal_to: [:agent],
          default: :agent,
          desired_state: false,
          description: 'Vault service operation mode. Defaults to agent.'

load_current_value do
  option_data = vault_hcl_config_current_load(config_file).fetch(vault_hcl_config_type, []).select { |t| t['destination'].eql?(destination) }

  current_value_does_not_exist! if nil_or_empty?(option_data)
  raise Chef::Exceptions::InvalidResourceReference,
        "Filter matched #{option_data.count} template configuration items but only should match one." if option_data.count > 1

  options option_data.first
end

action :create do
  raise 'The template resource can only be used in agent mode' unless new_resource.vault_mode.eql?(:agent)

  converge_if_changed { vault_hcl_resource_template_add }

  # We have to do this twice as the agent config file is accumulated and converge_if_changed won't always fire
  vault_hcl_resource_template_add if new_resource.vault_mode.eql?(:agent)
end

action :delete do
  converge_by('Remove configuration from accumulator template') { vault_hcl_resource_template_remove } if vault_hcl_resource_template?
end
