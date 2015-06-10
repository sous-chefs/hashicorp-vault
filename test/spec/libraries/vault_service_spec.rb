require 'spec_helper'

describe_recipe 'hashicorp-vault::default' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(step_into: 'vault_service').converge(described_recipe)
  end

  context 'with default attributes' do
    it { expect(chef_run).to create_poise_user('vault').with(group: 'vault') }
    it 'converges successfully' do
      chef_run
    end
  end
end
