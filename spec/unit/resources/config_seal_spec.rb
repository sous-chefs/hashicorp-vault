require 'spec_helper'

describe 'hashicorp_vault_config_seal' do
  step_into :hashicorp_vault_config_seal
  platform 'centos'

  context 'create seal HCL configuration' do
    recipe do
      hashicorp_vault_config_seal 'awskms' do
        options(
          'region' => 'us-east-1',
          'access_key' => 'AKIAIOSFODNN7EXAMPLE',
          'secret_key' => 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
          'kms_key_id' => '19ec80b0-dfdd-4d97-8164-c6examplekey',
          'endpoint' => 'https://vpce-0e1bb1852241f8cc6-pzi0do8n.kms.us-east-1.vpce.amazonaws.com'
        )
      end
    end

    it 'Creates the configuration file correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# seal/)
        .with_content(/seal "awskms" {/)
        .with_content(/  region = "us-east-1"/)
        .with_content(%r{  endpoint = "https:\/\/vpce-0e1bb1852241f8cc6-pzi0do8n.kms.us-east-1.vpce.amazonaws.com"})
    end
  end
end
