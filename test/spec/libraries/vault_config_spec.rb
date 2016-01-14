require 'spec_helper'
require 'poise_boiler/spec_helper'
require_relative '../../../libraries/vault_config'

describe VaultCookbook::Resource::VaultConfig do
  step_into(:vault_config)
  before do
    recipe = double('Chef::Recipe')
    allow_any_instance_of(Chef::RunContext).to receive(:include_recipe).and_return([recipe])
    allow_any_instance_of(Chef::Resource).to receive(:chef_vault_item) { { 'ca_certificate' => 'foo', 'certificate' => 'bar', 'private_key' => 'baz' }  }
    allow_any_instance_of(Chef::Provider).to receive(:chef_vault_item) { { 'ca_certificate' => 'foo', 'certificate' => 'bar', 'private_key' => 'baz' }  }
  end

  context '#action_create' do
    recipe do
      vault_config '/etc/vault/.vault.json' do
        tls_key_file '/etc/vault/ssl/private/vault.key'
        tls_cert_file '/etc/vault/ssl/certs/vault.crt'
        tls_ca_file '/etc/vault/ssl/certs/ca.crt'
      end
    end

    it { is_expected.to create_directory('/etc/vault/ssl/certs') }
    it { is_expected.to create_directory('/etc/vault/ssl/private') }

    it { is_expected.to render_file('/etc/vault/ssl/certs/vault.crt').with_content('bar') }
    it { is_expected.to render_file('/etc/vault/ssl/private/vault.key').with_content('baz') }
    it { is_expected.to render_file('/etc/vault/ssl/private/ca.crt').with_content('baz') }

    it { is_expected.to create_directory('/etc/vault') }
    it { is_expected.to render_file('/etc/vault/.vault.json') }
  end
end
