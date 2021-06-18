#
# Cookbook:: hashicorp-vault
# Resource:: config_auto_auth
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

unified_mode true

%w(base item item_type).each { |t| use "partial/_config_hcl_#{t}" }

property :entry_type, [String, Symbol],
          equal_to: %i(method sink),
          coerce: proc { |p| p.to_sym },
          required: true,
          identity: true,
          description: 'Vault auto_auth configuration element entry type'

property :path, String,
          identity: true,
          description: 'File path for sink configuration'

property :vault_mode, [String, Symbol],
          coerce: proc { |p| p.to_sym },
          equal_to: [:agent],
          default: :agent,
          desired_state: false,
          description: 'Vault service operation mode. Defaults to agent.'

load_current_value do |new_resource|
  case entry_type
  when :method
    option_data = vault_hcl_config_current_load(new_resource.config_file, vault_hcl_config_type).dig(new_resource.entry_type.to_s, new_resource.type)

    current_value_does_not_exist! if nil_or_empty?(option_data)

    options option_data
  when :sink
    option_data = vault_hcl_config_current_load(new_resource.config_file, vault_hcl_config_type).fetch(new_resource.entry_type.to_s, [])
    option_data = array_wrap(option_data).filter { |s| s.dig(type, 'config', 'path').eql?(path) }

    current_value_does_not_exist! if nil_or_empty?(option_data)
    raise Chef::Exceptions::InvalidResourceReference,
          "Filter matched #{option_data.count} auto_auth #{new_resource.entry_type} configuration items but only should match one." if option_data.count > 1

    option_data = option_data.first&.fetch(type)
    option_data['config']&.delete('path')

    options compact_hash(option_data)
  end

  if ::File.exist?(new_resource.config_file)
    owner ::Etc.getpwuid(::File.stat(new_resource.config_file).uid).name
    group ::Etc.getgrgid(::File.stat(new_resource.config_file).gid).name
    mode ::File.stat(new_resource.config_file).mode.to_s(8)[-4..-1]
  end
end

action :create do
  raise Chef::Exceptions::ValidationFailed, 'The path property is required for sink entries' if new_resource.entry_type.eql?(:sink) && !property_is_set?(:path)

  converge_if_changed { vault_hcl_resource_template_add }

  # We have to do this twice as the agent config file is accumulated and converge_if_changed won't always fire
  vault_hcl_resource_template_add if new_resource.vault_mode.eql?(:agent)
end

action :delete do
  raise Chef::Exceptions::ValidationFailed, 'The path property is required for sink entries' if new_resource.entry_type.eql?(:sink) && !property_is_set?(:path)

  converge_by('Remove configuration from accumulator template') { vault_hcl_resource_template_remove } if vault_hcl_resource_template?
end
