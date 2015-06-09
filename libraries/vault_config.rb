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

  attribute(:path, kind_of: String, name_attribute: true)
  attribute(:user, kind_of: String, default: 'vault')
  attribute(:group, kind_of: String, default: 'vault')

  # @see https://vaultproject.io/docs/config/index.html
  attribute(:listen_address, kind_of: String, default: '127.0.0.1:8200')
  attribute(:tls_disable, kind_of: [TrueClass, FalseClass], default: false)
  attribute(:tls_cert_file, kind_of: String)
  attribute(:tls_key_file, kind_of: String)
  attribute(:disable_mlock, kind_of: [TrueClass, FalseClass], default: false)
  attribute(:statsite_addr, kind_of: String)
  attribute(:statsd_addr, kind_of: String)
  attribute(:backend_type, equal_to: %i{consul zookeeper inmem file}, default: :inmem)
  attribute(:backend_options, options_collector: true)

  def tls?
    !tls_disable
  end

  def to_json
    invalid_options = %i{path user group backend_type backend_options}
    config = to_hash.reject { |k, v| invalid_options.include?(k) }
    JSON.pretty_generate(config.merge(backend_type => backend_options), quicks_mode: true)
  end

  action(:create) do
    # TODO: (jbellone) Perhaps we break this out and use chef-vault to
    # seed the initial secrets configuration here? I do not like the
    # idea of specifying this outside of the HWRP.
    if new_resource.tls?
      fail 'TLS certificate file must be set!' if new_resource.tls_cert_file.empty?
      fail 'TLS key file must be set!' if new_resource.tls_key_file.empty?
    end

    notifying_block do
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
