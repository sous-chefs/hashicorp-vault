require 'spec_helper'

describe_recipe 'hashicorp-vault::default' do
  context 'with default attributes' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(step_into: %w{vault_config}) do |node, server|
        server.create_data_bag('secrets', {
          'vault' => {
            'certificate' => 'foo',
            'private_key' => 'bar'
          }
        })
      end.converge(described_recipe)
    end

    it { expect(chef_run).to include_recipe('chef-vault::default') }
    it { expect(chef_run).to create_directory('/etc/ssl/certs') }
    it { expect(chef_run).to create_directory('/etc/ssl/private') }

    it do
      expect(chef_run).to create_file('/home/vault/.vault')
      .with(owner: 'vault')
      .with(group: 'vault')
      .with(mode: '0640')
    end

    it do
      expect(chef_run).to create_file('/etc/ssl/certs/vault.crt')
      .with(content: 'foo')
      .with(owner: 'vault')
      .with(group: 'vault')
      .with(mode: '0644')
    end

    it do
      expect(chef_run).to create_file('/etc/ssl/private/vault.key')
      .with(content: 'bar')
      .with(sensitive: true)
      .with(owner: 'vault')
      .with(group: 'vault')
      .with(mode: '0640')
    end

    it 'converges successfully' do
      chef_run
    end
  end

  context 'with TLS disabled' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(step_into: %w{vault_config}) do |node|
        node.set['vault']['config']['tls_disable'] = true
      end.converge(described_recipe)
    end

    it { expect(chef_run).not_to include_recipe('chef-vault::default') }
    it do
      expect(chef_run).to create_file('/home/vault/.vault')
      .with(owner: 'vault')
      .with(group: 'vault')
      .with(mode: '0640')
    end

    it 'converges successfully' do
      chef_run
    end
  end
end
