# require 'chefspec'
# require 'chefspec/policyfile'
# require 'poise_boiler/spec_helper'
# require_relative '../../libraries/vault_service'

# describe VaultCookbook::Resource::VaultService do
#   step_into(:vault_service)
#   context 'on Ubuntu platform' do
#     cached(:chef_run) do
#       ChefSpec::SoloRunner.new(
#         platform: 'ubuntu', version: '14.04', step_into: ['vault_service']
#       ).converge('hashicorp-vault::default')
#     end

#     before do
#       stub_command('getcap /opt/vault/1.0.0/vault|grep cap_ipc_lock+ep').and_return(false)
#     end

#     context 'with default properties' do
#       it 'should run setcap cap_ipc_lock' do
#         expect(chef_run).to run_execute 'setcap cap_ipc_lock=+ep /opt/vault/1.0.0/vault'
#       end
#     end
#   end

#   context 'on RHEL < 6' do
#     cached(:chef_run) do
#       ChefSpec::SoloRunner.new(
#         platform: 'redhat', version: '5.11', step_into: ['vault_service']
#       ).converge('hashicorp-vault::default')
#     end

#     it 'should not install libcap2-bin' do
#       expect(chef_run).to_not install_package('libcap2-bin')
#     end
#   end
# end
