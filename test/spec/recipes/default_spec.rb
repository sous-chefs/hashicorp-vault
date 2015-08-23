require 'spec_helper'

describe_recipe 'hashicorp-vault::default' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |_node, server|
      server.create_data_bag('secrets',
        'vault' => {
          'certificate' => 'foo',
          'private_key' => 'bar'
        })
    end.converge(described_recipe)
  end

  it { expect(chef_run).to create_poise_service_user('vault').with(group: 'vault') }
  it { expect(chef_run).to create_vault_config('/home/vault/.vault.json') }
  it { expect(chef_run).to run_execute 'setcap cap_ipc_lock=+ep /srv/vault/current/vault' }
  it { expect(chef_run).to enable_vault_service('vault').with(config_path: '/home/vault/.vault.json') }
  it { expect(chef_run).to start_vault_service('vault') }
  context 'with default attributes' do
    it 'converges successfully' do
      chef_run
    end
  end
end
