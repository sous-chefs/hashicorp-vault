#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'

# Resource for managing the Vault service on an instance.
# @since 1.0.0
class Chef::Resource::VaultService < Chef::Resource
  include Poise
  provides(:vault_service)
  include PoiseService::ServiceMixin
  default_action(:enable)

  # @!attribute service_name
  # @return [String]
  attribute(:service_name, kind_of: String, name_attribute: true)

  # @!attribute version
  # @return [String]
  attribute(:version, kind_of: String, required: true)

  # @!attribute install_method
  # @return [Symbol]
  attribute(:install_method, default: 'binary', equal_to: %w{source binary package})

  # @!attribute install_path
  # @return [String]
  attribute(:install_path, kind_of: String, default: '/srv')

  # @!attribute config_path
  # @return [String]
  attribute(:config_path, kind_of: String, default: '/home/vault/.vault.json')

  # @!attribute user
  # @return [String]
  attribute(:user, kind_of: String, default: 'vault')

  # @!attribute group
  # @return [String]
  attribute(:group, kind_of: String, default: 'vault')

  # @!attribute environment
  # @return [String]
  attribute(:environment, kind_of: Hash, default: { PATH: '/usr/local/bin:/usr/bin:/bin' })

  # @!attribute package_name
  # @return [String]
  attribute(:package_name, kind_of: String, default: 'vault')

  # @!attribute binary_url
  # @return [String]
  attribute(:binary_url, kind_of: String)

  # @!attribute source_url
  # @return [String]
  attribute(:source_url, kind_of: String)

  def command
    "/usr/local/bin/vault server -config=#{config_path}"
  end

  def binary_checksum
    node['vault']['checksums'].fetch(binary_filename)
  end

  def binary_filename
    arch = node['kernel']['machine'] =~ /x86_64/ ? 'amd64' : '386'
    [version, node['os'], arch].join('_')
  end
end

# Provider for managing the Vault service on an instance.
# @since 1.0.0
class Chef::Provider::VaultService < Chef::Provider
  include Poise
  provides(:vault_service)
  include PoiseService::ServiceMixin

  def action_enable
    notifying_block do
      package new_resource.package_name do
        version new_resource.version unless new_resource.version.nil?
        only_if { new_resource.install_method == 'package' }
      end

      if new_resource.install_method == 'binary'
        artifact = libartifact_file "vault-#{new_resource.version}" do
          artifact_name 'vault'
          artifact_version new_resource.version
          install_path new_resource.install_path
          remote_url new_resource.binary_url % { version: new_resource.binary_filename }
          remote_checksum new_resource.binary_checksum
        end

        link '/usr/local/bin/vault' do
          to ::File.join(artifact.current_path, 'vault')
        end
      end

      if new_resource.install_method == 'source'
        include_recipe 'golang::default'

        source_dir = directory ::File.join(new_resource.install_path, 'src') do
          recursive true
        end

        git ::File.join(source_dir.path, "vault-#{new_resource.version}") do
          repository new_resource.source_url
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
    service.directory(Dir.home(new_resource.user))
    service.user(new_resource.user)
    service.environment(new_resource.environment)
    service.restart_on_update(true)
  end
end
