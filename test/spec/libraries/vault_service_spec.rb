require 'spec_helper'
require 'poise_boiler/spec_helper'
require_relative '../../../libraries/vault_service'

describe VaultCookbook::Resource::VaultService do
  step_into(:vault_service)
  recipe 'hashicorp-vault::default'

  let(:chefspec_options) { {platform: 'ubuntu', version: '14.04'} }

  before do
    allow(File).to receive(:readlink).with('/usr/local/bin/vault').and_return('/srv/vault/current/vault')
    stub_command("getcap /srv/vault/current/vault|grep cap_ipc_lock+ep").and_return(false)
  end


  context 'with default properties' do
    it { is_expected.to create_link('/usr/local/bin/vault').with(to: '/srv/vault/current/vault')  }
    it { is_expected.to run_execute 'setcap cap_ipc_lock=+ep /srv/vault/current/vault' }
  end
end
