require 'spec_helper'

describe_recipe 'hashicorp-vault::default' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(step_into: 'vault_config').converge(described_recipe)
  end

  context 'with default attributes' do
    it 'converges successfully' do
      chef_run
    end
  end
end
