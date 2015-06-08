#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'

# @since 1.0.0
class Chef::Resource::VaultService < Chef::Resource
  provides(:vault_service)
  include PoiseService::ServiceMixin

  attribute(:service_name,
            kind_of: String,
            name_attribute: true)
  attribute(:user,
            kind_of: String,
            default: 'vault')
  attribute(:group,
            kind_of: String,
            default: 'vault')
  attribute(:environment,
            kind_of: Hash,
            default: lazy { default_environment })

  def binary_url
  end

  def binary_checksum
  end

  def default_environment
    { PATH: '/usr/local/bin:/usr/bin' }
  end
end

# @since 1.0.0
class Chef::Provider::VaultService < Chef::Provider
  provides(:vault_service)
  include PoiseService::ServiceMixin

  def action_enable
    notifying_block do
      poise_service_user new_resource.user do
        group new_resource.group
      end

      include_recipe 'libartifact::default'
      libartifact_file "vault-#{new_resource.version}" do
        artifact_name 'vault'
        artifact_version new_resource.version
        install_path new_resource.install_path
        binary_url new_resource.binary_url
        binary_checksum new_resource.binary_checksum
      end

      poise_service new_resource.service_name do
        user new_resource.user
        action :enable
      end
    end

  end

  def action_disable
  end

  def service_options(service)
    service.command()
    service.user(new_resource.user)
    service.environment(new_resource.environment)
  end
end
