#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
require 'poise'

# @since 1.0.0
class Chef::Resource::VaultConfig < Chef::Resource
  include Poise(fused: true)
  provides(:vault_config)

  attribute(:instance_name,
            kind_of: String,
            name_attribute: true)
  attribute(:user,
            kind_of: String,
            default: 'vault')
  attribute(:group,
            kind_of: String,
            default: 'vault')

  action(:create) do

  end

  action(:delete) do

  end
end
