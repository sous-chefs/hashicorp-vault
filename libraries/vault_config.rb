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

  attribute(:config_filename, kind_of: String, name_attribute: true)
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

  action(:create) do

  end

  action(:delete) do

  end
end
