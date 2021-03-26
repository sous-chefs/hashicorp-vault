require 'spec_helper'

describe 'hashicorp_vault_config_entropy' do
  step_into :hashicorp_vault_config_entropy
  platform 'centos'

  context 'create entropy HCL configuration' do
    recipe do
      hashicorp_vault_config_entropy 'seal' do
        type 'seal'
        options(
          'mode' => 'augmentation'
        )
      end
    end

    it 'Creates the configuration file correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# entropy/)
        .with_content(/entropy "seal" {/)
        .with_content(/  mode = "augmentation"/)
    end
  end
end
