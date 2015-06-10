require 'spec_helper'

describe_recipe 'hashicorp-vault::default' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(step_into: 'vault_config').converge(described_recipe)
  end

  context 'with default attributes' do
    it { expect(chef_run).to include_recipe('chef-vault::default') }
    it { expect(chef_run).to create_directory('/etc/ssl/certs') }
    it { expect(chef_run).to create_directory('/etc/ssl/private') }

    it do
      expect(chef_run).to create_file('/etc/ssl/certs/vault.cert')
      .with(owner: 'vault')
      .with(group: 'vault')
      .with(mode: '0644')
    end

    it do
      expect(chef_run).to create_file('/etc/ssl/private/vault.pem')
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
      ChefSpec::ServerRunner.new(step_into: 'vault_config') do |node|
        node.set['vault']['config']['tls_disable'] = true
      end.converge(described_recipe)
    end

    it { expect(chef_run).to_not include_recipe('chef-vault::default') }

    it 'converges successfully' do
      chef_run
    end
  end
end
