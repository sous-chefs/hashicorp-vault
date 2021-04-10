require 'spec_helper'

describe 'hashicorp_vault_config_storage' do
  step_into :hashicorp_vault_config_storage
  platform 'centos'

  context 'create file storage HCL configuration' do
    recipe do
      hashicorp_vault_config_storage 'file test' do
        type 'file'
        options(
          'path' => '/opt/vault/data'
        )
      end
    end

    it 'Creates the configuration file correctly' do
      is_expected.to render_file('/etc/vault.d/config_storage_file_test.hcl')
        .with_content(/# storage/)
        .with_content(/storage "file" {/)
        .with_content(%r{  path = "\/opt\/vault\/data"})
    end
  end

  context 'create inmem storage HCL configuration' do
    recipe do
      hashicorp_vault_config_storage 'inmem test' do
        type 'inmem'
      end
    end

    it 'Creates the configuration file correctly' do
      is_expected.to render_file('/etc/vault.d/config_storage_inmem_test.hcl')
        .with_content(/# storage/)
        .with_content(/storage "inmem" {/)
    end
  end
end
