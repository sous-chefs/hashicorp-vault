require 'spec_helper'

describe 'hashicorp_vault_config_auto_auth' do
  step_into :hashicorp_vault_config_auto_auth
  platform 'centos'

  context 'create a method auto auth HCL configuration' do
    recipe do
      hashicorp_vault_config_auto_auth 'aws' do
        entry_type :method
        type 'aws'
        options(
          'mount_path' => 'auth/aws-subaccount',
          'config' => {
            'type' => 'iam',
            'role' => 'foobar',
          }
        )
      end
    end

    it 'Creates the configuration file correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# auto_auth/)
        .with_content(%r{  mount_path = "auth\/aws-subaccount"})
        .with_content(/      type = "iam"/)
    end
  end

  context 'create a sink auto auth HCL configuration' do
    recipe do
      hashicorp_vault_config_auto_auth 'file' do
        entry_type :sink
        type 'file'
        path '/tmp/file-bar'
        options(
          'wrap_ttl' => '5m',
          'aad_env_var' => 'TEST_AAD_ENV',
          'dh_type' => 'curve25519',
          'dh_path' => '/tmp/file-foo-dhpath2'
        )
      end
    end

    it 'Creates the configuration file correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# auto_auth/)
        .with_content(/  dh_type = "curve25519"/)
        .with_content(%r{      path = "\/tmp\/file-bar"})
    end
  end

  context 'create a combined method auto auth HCL configuration' do
    recipe do
      hashicorp_vault_config_auto_auth 'aws_test' do
        entry_type :method
        type 'aws'
        options(
          'mount_path' => 'auth/aws-subaccount',
          'config' => {
            'type' => 'iam',
            'role' => 'foobar',
          }
        )
      end

      hashicorp_vault_config_auto_auth 'aws_test' do
        entry_type :sink
        type 'file'
        path '/tmp/file-bar'
        options(
          'wrap_ttl' => '5m',
          'aad_env_var' => 'TEST_AAD_ENV',
          'dh_type' => 'curve25519',
          'dh_path' => '/tmp/file-foo-dhpath2'
        )
      end
    end

    it 'Creates the configuration file correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# auto_auth/)
        .with_content(/method "aws"/)
        .with_content(%r{  mount_path = "auth\/aws-subaccount"})
        .with_content(/      type = "iam"/)
        .with_content(/sink "file"/)
        .with_content(/  dh_type = "curve25519"/)
        .with_content(%r{      path = "\/tmp\/file-bar"})
    end
  end
end
