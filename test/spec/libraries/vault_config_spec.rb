require 'poise_boiler/spec_helper'
require_relative '../../../libraries/vault_config'

describe VaultCookbook::Resource::VaultConfig do
  step_into(:vault_config)
  context '#action_create' do
    before do
      recipe = double('Chef::Recipe')
      allow_any_instance_of(Chef::RunContext).to receive(:include_recipe).and_return([recipe])
      allow_any_instance_of(Chef::Provider).to receive(:chef_vault_item) { { 'ca_certificate' => 'foo', 'certificate' => 'bar', 'private_key' => 'baz' } }
    end

    recipe do
      vault_config '/etc/vault/vault.json' do
        tls_key_file '/etc/vault/ssl/private/vault.key'
        tls_cert_file '/etc/vault/ssl/certs/vault.crt'
      end
    end

    it { is_expected.to create_directory('/etc/vault/ssl/certs') }
    it { is_expected.to create_directory('/etc/vault/ssl/private') }

    it do
      is_expected.to create_file('/etc/vault/ssl/certs/vault.crt')
        .with(content: 'bar')
        .with(owner: 'vault')
        .with(group: 'vault')
        .with(mode: '0644')
    end

    it do
      is_expected.to create_file('/etc/vault/ssl/private/vault.key')
        .with(content: 'baz')
        .with(sensitive: true)
        .with(owner: 'vault')
        .with(group: 'vault')
        .with(mode: '0640')
    end

    it { is_expected.to create_directory('/etc/vault') }
    it { is_expected.to create_file('/etc/vault/vault.json') }
  end
end
