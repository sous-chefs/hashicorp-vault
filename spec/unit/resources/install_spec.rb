require 'spec_helper'

describe 'hashicorp_vault_install' do
  step_into :hashicorp_vault_install
  platform 'centos'

  context 'install vault' do
    recipe do
      hashicorp_vault_install 'package'
    end

    describe 'creates repo and installs vault' do
      it { is_expected.to create_yum_repository('hashicorp') }
      it { is_expected.to create_yum_repository('hashicorp-test') }
      it { is_expected.to install_package('vault') }
    end
  end
end
