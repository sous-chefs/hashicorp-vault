require 'spec_helper'

describe 'hashicorp_vault_config_template' do
  step_into :hashicorp_vault_config_template
  platform 'centos'

  context 'create service registration HCL configuration' do
    recipe do
      hashicorp_vault_config_template '/etc/vault/server.key' do
        options(
          'source' => '/etc/vault/server.key.ctmpl',
          'destination' => '/etc/vault/server.key'
        )
      end

      hashicorp_vault_config_template '/etc/vault/server.crt' do
        options(
          'source' => '/etc/vault/server.crt.ctmpl',
          'destination' => '/etc/vault/server.crt'
        )
      end
    end

    it 'Creates the configuration file correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# template/)
        .with_content(/template {/)
        .with_content(%r{  source = "/etc/vault/server.crt.ctmpl"})
        .with_content(%r{  destination = "/etc/vault/server.crt"})

      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# template/)
        .with_content(/template {/)
        .with_content(%r{  source = "/etc/vault/server.key.ctmpl"})
        .with_content(%r{  destination = "/etc/vault/server.key"})
    end
  end
end
