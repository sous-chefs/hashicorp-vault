# require 'chefspec'
# require 'chefspec/policyfile'

# describe 'hashicorp-vault::default' do
#   before do
#     stub_command('test -L /opt/vault/1.0.0/vault').and_return(true)
#     stub_command('getcap /opt/vault/1.0.0/vault|grep cap_ipc_lock+ep').and_return(false)
#   end

#   context 'with default node attributes' do
#     cached(:chef_run) do
#       ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge('hashicorp-vault::default')
#     end

#     it { expect(chef_run).to create_poise_service_user('vault').with(group: 'vault') }
#     it { expect(chef_run).to create_vault_config('/etc/vault/vault.json') }
#     it { expect(chef_run).to create_vault_installation('1.0.0') }
#     it { expect(chef_run).to enable_vault_service('vault').with(config_path: '/etc/vault/vault.json') }
#     it { expect(chef_run).to start_vault_service('vault') }
#   end
# end
