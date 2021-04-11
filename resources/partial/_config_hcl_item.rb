#
# Cookbook:: hashicorp-vault
# Resource:: _config_hcl_item
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

property :options, Hash,
          default: lazy { default_vault_config_hcl(vault_hcl_config_type) },
          description: 'Vault server configuration element configuration.'

property :description, String,
          desired_state: false,
          description: 'Unparsed description to add to the configuration file.'
