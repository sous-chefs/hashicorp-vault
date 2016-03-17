require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'
require 'poise_boiler/spec_helper'
require_relative '../../../libraries/vault_service'

describe VaultCookbook::Resource::VaultService do
  step_into(:vault_service)
  recipe 'hashicorp-vault::default'

  let(:chefspec_options) { {platform: 'ubuntu', version: '14.04', log_level: :debug} }

  before do
    stub_command("getcap /opt/vault/0.5.2/vault|grep cap_ipc_lock+ep").and_return(false)
  end

  context 'with default properties' do
    it { is_expected.to run_execute 'setcap cap_ipc_lock=+ep /opt/vault/0.5.2/vault' }
  end
end
