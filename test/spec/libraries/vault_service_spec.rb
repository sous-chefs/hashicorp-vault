require 'spec_helper'

describe_recipe 'hashicorp-vault::default' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(step_info: %w{vault_service}) do |node, server|
      server.create_data_bag('secrets', {
        'vault' => {
          'certificate' => 'foo',
          'private_key' => 'bar'
        }
      })
    end.converge(described_recipe)
  end

  context 'with default attributes' do
    it 'converges successfully' do
      chef_run
    end
  end
end
