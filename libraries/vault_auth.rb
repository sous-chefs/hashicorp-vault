#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2016, Parallels IP Holdings GmbH.
#
require 'poise'

# Inspiration from sethvargo's gist
module VaultCookbook
  module Resource
    # A `vault_auth` resource for reading secrets out of Vault
    # @action auth
    # @provides vault_auth
    # @since 2.5
    class VaultAuth < Chef::Resource
      include Poise(fused: true)
      provides(:vault_auth)
      actions(:auth)
      default_action(:auth)

      # @!attribute address
      # The address of Vault server, for example: "http://127.0.0.1:8200"
      # supported.
      # @return [String]
      attribute(:address, kind_of: String, name_attribute: true)

      # @!attribute token
      # The Vault token. If specified, the resource will try to renew this
      # token first. If the renewal fails, the regular auth will be performed.
      # @return [String]
      attribute(:token, kind_of: [String, NilClass], default: nil)

      # @!attribute type
      # The authentication type (auth backend). Currently, only "approle" is
      # supported.
      # @return [String]
      attribute(:type, equal_to: ['approle'], default: 'approle')

      # @!attribute role_id
      # RoleID of the AppRole to pass to the auth backend. It is required for
      # "approle" type.
      # @return [String]
      attribute(:role_id, kind_of: String)

      # @!attribute secret_id
      # SecretID belonging to AppRole. It is required for "approle" type if
      # Vault auth backend has "bind_secret_id" option enabled.
      # @return [String]
      attribute(:secret_id, kind_of: [String, NilClass], default: nil)

      # @!attribute attempts
      # The number of attempts to authenticate with Vault.
      # @return [Fixnum]
      attribute(:attempts, kind_of: Fixnum, default: 2)

      # The run state reference where the auth token will be saved for further
      # interactions.
      # @return [String]
      attribute(:run_state_reference, kind_of: [String], default: 'vault_token')

      # Raise an exeption if the authenticaton wasn't succeessfull
      attribute(:exit_on_error, kind_of: [TrueClass, FalseClass], default: true)

      # @see https://github.com/hashicorp/vault-ruby
      attribute(:proxy_address, kind_of: String)
      attribute(:proxy_port, kind_of: String)
      attribute(:proxy_username, kind_of: String)
      attribute(:proxy_password, kind_of: String)
      attribute(:ssl_pem_file, kind_of: String)
      attribute(:ssl_verify, kind_of: [TrueClass, FalseClass])
      attribute(:timeout, kind_of: Fixnum)
      attribute(:ssl_timeout, kind_of: Fixnum)
      attribute(:open_timeout, kind_of: Fixnum)
      attribute(:read_timeout, kind_of: Fixnum)

      def config_options
        %i(proxy_address proxy_port proxy_username proxy_password ssl_pem_file
           ssl_verify timeout ssl_timeout open_timeout read_timeout)
      end

      def config
        to_hash.keep_if do |k, _|
          config_options.include?(k.to_sym)
        end.merge(address: address)
      end

      action(:auth) do
        notifying_block do
          token = new_resource.token || node.run_state[new_resource.run_state_reference]
          begin
            require 'vault'
            client = Vault::Client.new(new_resource.config)

            # We already have a token, try to renew it
            unless token.nil?
              client.token = token
              client.auth_token.renew_self
              # Store the token in-memory for the rest of the Chef run
              node.run_state[new_resource.run_state_reference] = token
              new_resource.updated_by_last_action(false)
              return
            end
          rescue LoadError
            raise 'The "vault" gem is required. Include recipe[hashicorp-vault::gems] to install it.'
          rescue Vault::HTTPClientError => e
            # Renewal failed - token could have been:
            # manually revoked, or not renewed in time
            Chef::Log.warn("Failed to renew the existing token. Attempting to authenticate.\n" + e.message)
          end

          begin
            max_attempts = new_resource.attempts
            secret = client.with_retries(Vault::HTTPError, Vault::HTTPConnectionError, attempts: max_attempts) do |attempts, error|
              unless attempts == 0
                Chef::Log.info "Received exception #{error.class} from Vault - attempt #{attempts}"
              end
              client.auth.approle(new_resource.role_id, new_resource.secret_id)
            end
          rescue Vault::HTTPError => e
            message = "Failed to authenticate with Vault\n#{e.message}"
            raise message if new_resource.exit_on_error
            Chef::Log.fatal message
          end

          if secret.nil?
            message = 'Could not fetch the authentication token!'
            raise message if new_resource.exit_on_error
            Chef::Log.fatal message
            return
          end

          # Store the token in-memory for the rest of the Chef run
          node.run_state[new_resource.run_state_reference] = secret.auth.client_token
          new_resource.updated_by_last_action(true)
        end
      end
    end
  end
end
