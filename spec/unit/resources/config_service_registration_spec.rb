require 'spec_helper'

describe 'hashicorp_vault_config_service_registration' do
  step_into :hashicorp_vault_config_service_registration
  platform 'centos'

  context 'create service registration HCL configuration' do
    recipe do
      hashicorp_vault_config_service_registration 'kubernetes' do
        type 'kubernetes'
        options(
          'namespace' => 'my-namespace',
          'pod_name' => 'my-pod-name'
        )
      end
    end

    it 'Creates the configuration file correctly' do
      is_expected.to render_file('/etc/vault.d/config_service_registration_kubernetes.hcl')
        .with_content(/# service_registration/)
        .with_content(/service_registration "kubernetes" {/)
        .with_content(/  namespace = "my-namespace"/)
        .with_content(/  pod_name = "my-pod-name"/)
    end
  end
end
