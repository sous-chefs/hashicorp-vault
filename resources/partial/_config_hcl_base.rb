#
# Cookbook:: hashicorp-vault
# Resource:: _config_hcl_base
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

property :config_dir, String,
          default: lazy { default_vault_config_dir },
          description: 'Set to override vault configuration directory.'

property :config_file, String,
          default: lazy { default_vault_config_file(:hcl) },
          description: 'Set to override vault configuration file. Defaults to /etc/vault.d/{CONFIG_TYPE}_{name}.hcl',
          desired_state: false

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

property :vault_mode, [String, Symbol],
          coerce: proc { |p| p.to_sym },
          equal_to: [:server, :agent],
          default: :server,
          desired_state: false,
          description: 'Vault service operation mode. Defaults to server.'

action_class do
  include Vault::Cookbook::Helpers
  include Vault::Cookbook::ResourceHelpers
end
