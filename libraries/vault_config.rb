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

  # @!attribute path
  # @return [String]
  attribute(:path, kind_of: String, name_attribute: true)

  # @!attribute user
  # @return [String]
  attribute(:user, kind_of: String, default: 'vault')

  # @!attribute group
  # @return [String]
  attribute(:group, kind_of: String, default: 'vault')

  # @see https://vaultproject.io/docs/config/index.html
  attribute(:listen_address, kind_of: [String. NilClass], default: nil)
  attribute(:tls_disable, kind_of: [TrueClass, FalseClass, NilClass], default: nil)
  attribute(:tls_cert_file, kind_of: [String, NilClass], default: nil)
  attribute(:tls_key_file, kind_of: [String, NilClass], default: nil)
  attribute(:disable_mlock, kind_of: [TrueClass, FalseClass, NilClass], default: nil)
  attribute(:statsite_addr, kind_of: [String, NilClass], default: nil)
  attribute(:statsd_addr, kind_of: [String, NilClass], default: nil)
  attribute(:backend_type,
            kind_of: Symbol,
            default: :inmem,
            equal_to: %i{consul zookeeper inmem file})
  attribute(:backend_options, options_collector: true)

  def tls?
    !tls_disable
  end

  # Transforms the resource into a JSON format which matches the
  # Vault service's configuration format.
  # @see https://vaultproject.io/docs/config/index.html
  def to_json
    invalid_options = %i{path user group backend_type backend_options}
    config = to_hash.reject do |k, v|
      return true if v.nil?
      invalid_options.include?(k.to_sym)
    end.merge(backend_type => (backend_options || {}))
    JSON.pretty_generate(config, quirks_mode: true)
  end

  action(:create) do
    notifying_block do
      if new_resource.tls?
        include_recipe 'chef-vault::default'

        item = chef_vault_item_for_environment(node['vault']['bag_name'], node['vault']['bag_item'])
        directory ::File.dirname(new_resource.tls_cert_file) do
          recursive true
          owner 'root'
          group 'root'
          mode '0644'
        end

        file new_resource.tls_cert_file do
          content item['certificate']
          mode '0644'
          owner new_resource.user
          group new_resource.group
        end

        directory ::File.dirname(new_resource.tls_key_file) do
          recursive true
          mode '0640'
          owner 'root'
          group 'root'
        end

        file new_resource.tls_key_file do
          sensitive true
          content item['private_key']
          mode '0640'
          owner new_resource.user
          group new_resource.group
        end
      end

      directory ::File.dirname(new_resource.path) do
        recursive true
        mode '0644'
      end

      file new_resource.path do
        content new_resource.to_json
        owner new_resource.user
        group new_resource.group
        mode '0640'
      end
    end
  end

  action(:delete) do
    notifying_block do
      file new_resource.path do
        action :delete
      end
    end
  end
end
