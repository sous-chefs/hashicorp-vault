# frozen_string_literal: true

require 'spec_helper'

describe 'hashicorp_vault_service' do
  step_into :hashicorp_vault_service
  platform 'centos'

  context 'create a vault service and verify service is created properly' do
    recipe do
      hashicorp_vault_service 'vault' do
        action %i(create enable start)
      end
    end

    describe 'creates systemd unit file' do
      it { is_expected.to create_systemd_unit('vault.service') }
    end

    describe 'enables and starts service' do
      it { is_expected.to enable_service('vault') }
      it { is_expected.to start_service('vault') }
    end
  end

  context 'delete a service with an explicit name' do
    recipe do
      hashicorp_vault_service 'resource-name' do
        service_name 'custom-vault.service'
        action :delete
      end
    end

    it { is_expected.to stop_service('custom-vault') }
    it { is_expected.to disable_service('custom-vault') }
    it { is_expected.to delete_systemd_unit('custom-vault.service') }
  end
end
