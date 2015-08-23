#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
require 'poise'

module VaultCookbook
  module Resource
    # @since 1.0.0
    class VaultConfig < Chef::Resource
      include Poise(fused: true)
      provides(:vault_config)
      default_action(:create)

      # @!attribute path
      # @return [String]
      attribute(:path, kind_of: String, name_attribute: true)

      # @!attribute owner
      # @return [String]
      attribute(:owner, kind_of: String, default: 'vault')

      # @!attribute group
      # @return [String]
      attribute(:group, kind_of: String, default: 'vault')

      attribute(:bag_name, kind_of: String, default: 'secrets')
      attribute(:bag_item, kind_of: String, default: 'vault')

      # @see https://vaultproject.io/docs/config/
      attribute(:config, kind_of: Hash)

      def tls?
        return false if config['listener'].key?('tls_disable') && config['listener']['tls_disable'].any?

        node['vault']['manage_certificate']
      end

      def tls_cert_file
        config['listener']['tcp']['tls_cert_file']
      end

      def tls_key_file
        config['listener']['tcp']['tls_key_file']
      end

      action(:create) do
        notifying_block do
          if new_resource.tls?
            include_recipe 'chef-vault::default'

            directory ::File.dirname(new_resource.tls_cert_file) do
              recursive true
              owner 'root'
              group new_resource.group
              mode '0755'
            end

            item = chef_vault_item(
              new_resource.bag_name,
              new_resource.bag_item
            )
            file new_resource.tls_cert_file do
              content item['certificate']
              mode '0644'
              owner new_resource.owner
              group new_resource.group
            end

            directory ::File.dirname(new_resource.tls_key_file) do
              recursive true
              mode '0750'
              owner 'root'
              group new_resource.group
            end

            file new_resource.tls_key_file do
              sensitive true
              content item['private_key']
              mode '0640'
              owner new_resource.owner
              group new_resource.group
            end
          end

          directory ::File.dirname(new_resource.path) do
            recursive true
          end

          file new_resource.path do
            content json_config new_resource.config
            owner new_resource.owner
            group new_resource.group
            mode '0640'
          end
        end
      end

      action(:delete) do
        notifying_block do
          if new_resource.tls?
            file new_resource.tls_cert_file do
              action :delete
            end

            file new_resource.tls_key_file do
              action :delete
            end
          end

          file new_resource.path do
            action :delete
          end
        end
      end
    end
  end
end
