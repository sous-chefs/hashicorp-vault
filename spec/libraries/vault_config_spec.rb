require 'chefspec'
require 'chefspec/policyfile'
require 'poise_boiler/spec_helper'
require_relative '../../libraries/vault_config'

describe VaultCookbook::Resource::VaultConfig do
  step_into(:vault_config)
  let(:chefspec_options) { { platform: 'ubuntu', version: '16.04', log_level: :debug } }

  context '#action_create' do
    recipe do
      vault_config '/etc/vault/vault.json' do
        tls_key_file '/etc/vault/ssl/private/vault.key'
        tls_cert_file '/etc/vault/ssl/certs/vault.crt'
      end
    end

    it { is_expected.to create_directory('/etc/vault') }
    it { is_expected.to render_file('/etc/vault/vault.json') }
  end
end
