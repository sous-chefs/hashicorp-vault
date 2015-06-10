require 'spec_helper'

describe_recipe 'hashicorp-vault::default' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |node, server|
      server.create_data_bag('secrets', {
        'vault' => {
          'certificate' => 'foo',
          'private_key' => 'bar'
        }
      })
    end.converge(described_recipe)
  end

  it { expect(chef_run).to create_vault_config('/etc/vault/default.json') }
  it { expect(chef_run).to enable_vault_service('vault').with(config_filename: '/etc/vault/default.json') }
  context 'with default attributes' do
    it 'converges successfully' do
      chef_run
    end
  end
end
