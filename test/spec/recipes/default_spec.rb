require 'spec_helper'

describe_recipe 'hashicorp-vault::default' do
  it { expect(chef_run).to create_vault_config('vault') }
  it { expect(chef_run).to enable_vault_service('vault') }
  context 'with default attributes' do
    it 'converges successfully' do
      chef_run
    end
  end
end
