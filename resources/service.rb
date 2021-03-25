#
# Cookbook:: hashicorp-vault
# Resource:: service
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

property :service_name, String,
          coerce: proc { |p| "#{p}.service" },
          default: lazy { default_vault_service_name },
          description: 'Set to override service name. Defaults to vault.'

property :config_type, [Symbol, String],
          coerce: proc { |p| p.to_sym },
          equal_to: [:hcl, :json],
          default: :hcl,
          description: 'Vault configuration type used. Defaults to HCL.'

property :systemd_unit_content, [String, Hash],
          default: lazy { default_vault_unit_content },
          description: 'Override the systemd unit file contents'

property :vault_binary_path, String,
          default: '/usr/bin/vault',
          description: 'Path to the vault binary on disk.'

property :user, String,
          default: lazy { default_vault_user },
          description: 'Set to override default vault user. Defaults to vault.'

property :group, String,
          default: lazy { default_vault_group },
          description: 'Set to override default vault group. Defaults to vault.'

property :config_file, String,
          default: lazy { default_vault_config_file(config_type) },
          description: 'Set to override vault configuration file.'

property :mode, [String, Symbol],
          coerce: proc { |p| p.to_sym },
          equal_to: [:server, :agent],
          default: :server,
          description: 'Vault service operation mode. Defaults to server.'

action_class do
  def do_service_action(resource_action)
    declare_resource(:service, new_resource.service_name.delete_suffix('.service')) do
      supports status: true, restart: true, reload: true

      action resource_action
    end
  end
end

action :create do
  systemd_unit new_resource.service_name do
    content new_resource.systemd_unit_content
    triggers_reload true

    action :create
  end
end

action :delete do
  do_service_action(:stop)

  systemd_unit new_resource.name do
    triggers_reload true

    action :delete
  end
end

%i(start stop restart reload enable disable).each do |action_type|
  send(:action, action_type) { do_service_action(action) }
end
