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
  attribute(:version,
            kind_of: String,
            required: true)
  attribute(:install_method,
            kind_of: Symbol,
            required: true,
            equal_to: %i{source binary})
  attribute(:install_path,
            kind_of: String,
            default: '/srv')
  attribute(:config_filename,
            kind_of: String,
            default: '/etc/vault.json')
  attribute(:user,
            kind_of: String,
            default: 'vault')
  attribute(:group,
            kind_of: String,
            default: 'vault')
  attribute(:environment,
            kind_of: Hash,
            default: { PATH: '/usr/local/bin:/usr/bin:/bin' })
  attribute(:binary_url, kind_of: String)
  attribute(:source_repository, kind_of: String)

  def command
    "vault server -config #{config_filename}"
  end

  def binary_checksum
    node['vault']['checksums'].fetch(binary_filename)
  end

  def binary_filename
    arch = node['kernel']['machine'] =~ /x86_64/ ? 'amd64' : '386'
    [version, node['os'], arch].join('_')
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

      if new_resource.install_method == 'binary'
        artifact = libartifact_file "vault-#{new_resource.version}" do
          artifact_name 'vault'
          artifact_version new_resource.version
          install_path new_resource.install_path
          remote_url new_resource.binary_url
          remote_checksum new_resource.binary_checksum
        end

        link '/usr/local/bin/vault' do
          to artifact.current_path
        end
      end

      if new_resource.install_method == 'source'
        include_recipe 'golang::default'

        source_dir = directory ::File.join(new_resource.install_path, 'src') do
          recursive true
        end

        git ::File.join(source_dir.path, "vault-#{new_resource.version}") do
          repository new_resource.source_repository
          reference new_resource.version
          action :checkout
        end

        golang_package 'github.com/hashicorp/vault' do
          action :install
        end

        directory ::File.join(new_resource.install_path, 'bin')

        link ::File.join(new_resource.install_path, 'bin', 'vault') do
          to ::File.join(source_dir.path, "vault-#{new_resource.version}", 'vault')
        end
      end
    end
    super
  end

  def service_options(service)
    service.command(new_resource.command)
    service.user(new_resource.user)
    service.environment(new_resource.environment)
    service.restart_on_update(true)
  end
end
