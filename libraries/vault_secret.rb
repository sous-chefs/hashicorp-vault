#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

# Inspiration from sethvargo's gist
module VaultCookbook
  module Resource
    # A `vault_secret` resource for reading secrets out of Vault
    # @action read
    # @provides vault_secret
    # @since 2.2
    class VaultSecret < Chef::Resource
      include Poise(fused: true)
      provides(:vault_secret)
      actions(:read)
      default_action(:read)

      # @!attribute path
      # The secret path in Vault.
      # @return [String]
      attribute(:path, kind_of: String, name_attribute: true)
      # @!attribute attempts
      # The number of attempts to try & read a Vault secret.
      # @return [Integer]
      attribute(:attempts, kind_of: Integer, default: 2)
      # The run state reference where the secret value will be saved,
      # e.q. node.run_state['run_state_reference']
      # @return [String]
      attribute(:run_state_reference, kind_of: String, default: nil)
      # Raise an exeption if the secret could not be read
      attribute(:exit_on_error, kind_of: [TrueClass, FalseClass], default: true)
      # @see https://github.com/hashicorp/vault-ruby
      attribute(:address, kind_of: String, required: true)
      attribute(:token, kind_of: String)
      attribute(:proxy_address, kind_of: String)
      attribute(:proxy_port, kind_of: String)
      attribute(:proxy_username, kind_of: String)
      attribute(:proxy_password, kind_of: String)
      attribute(:ssl_ca_cert, kind_of: String)
      attribute(:ssl_pem_file, kind_of: String)
      attribute(:ssl_pem_contents, kind_of: String)
      attribute(:ssl_verify, kind_of: [TrueClass, FalseClass])
      attribute(:timeout, kind_of: Integer)
      attribute(:ssl_timeout, kind_of: Integer)
      attribute(:open_timeout, kind_of: Integer)
      attribute(:read_timeout, kind_of: Integer)

      def config_options
        %i(address token proxy_address proxy_port proxy_username proxy_password
           ssl_pem_file ssl_pem_contents ssl_ca_cert ssl_verify
           timeout ssl_timeout open_timeout read_timeout)
      end

      def config
        to_hash.keep_if do |k, _|
          config_options.include?(k.to_sym)
        end
      end

      action(:read) do
        notifying_block do
          run_context.include_recipe 'hashicorp-vault::gems'

          node.default_unless['hashicorp-vault']['leases'] = {}
          lease_id = node['hashicorp-vault']['leases'][new_resource.path]

          begin
            client = Vault::Client.new(new_resource.config)

            # We have a lease for this secret, try to renew it
            unless lease_id.nil?
              client.sys.renew(lease_id)
              new_resource.updated_by_last_action(false)
              return
            end
          rescue Vault::HTTPClientError => e
            # Renewal failed - lease could have been:
            # manually revoked, or not renewed in time
            Chef::Log.warn("Failed to renew #{new_resource.path}. Attempting a fresh read.\n" + e.message)
          end

          begin
            max_attempts = new_resource.attempts
            secret = client.with_retries(Vault::HTTPError, Vault::HTTPConnectionError, attempts: max_attempts) do |attempts, error|
              unless attempts == 0
                Chef::Log.info "Received exception #{error.class} from Vault - attempt #{attempts}"
              end
              client.logical.read(new_resource.path)
            end
          rescue Vault::HTTPError => e
            message = "Failed to read secret - #{new_resource.path}.\n#{e.message}"
            raise message if new_resource.exit_on_error
            Chef::Log.fatal message
          end

          if secret.nil?
            message = "Could not read secret - #{new_resource.path}"
            raise message if new_resource.exit_on_error
            Chef::Log.fatal message
            return
          end

          node.set['hashicorp-vault']['leases'][new_resource.path] = secret.lease_id if secret.renewable?
          # Store secret in-memory for the rest of the Chef run
          reference = new_resource.run_state_reference || new_resource.path
          node.run_state[reference] = secret
          new_resource.updated_by_last_action(true)
        end
      end
    end
  end
end
