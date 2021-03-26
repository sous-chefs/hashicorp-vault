require 'spec_helper'

describe 'hashicorp_vault_config_listener' do
  step_into :hashicorp_vault_config_listener
  platform 'centos'

  context 'create listener HCL configuration' do
    recipe do
      hashicorp_vault_config_listener 'tcp' do
        type 'tcp'
        options(
          'address' => '127.0.0.1:8200',
          'cluster_address' => '127.0.0.1:8201',
          'tls_cert_file' => '/opt/vault/tls/tls.crt',
          'tls_key_file' => '/opt/vault/tls/tls.key',
          'telemetry' => {
            'unauthenticated_metrics_access' => false,
          }
        )
      end
    end

    it 'Creates the configuration file correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# listener/)
        .with_content(/listener "tcp" {/)
        .with_content(/  cluster_address = "127.0.0.1:8201"/)
        .with_content(/    unauthenticated_metrics_access = false/)
    end
  end
end
