require 'spec_helper'

describe 'hashicorp_vault_config_hcl' do
  step_into %i(
    hashicorp_vault_config_auto_auth
    hashicorp_vault_config_entropy
    hashicorp_vault_config_listener
    hashicorp_vault_config_seal
    hashicorp_vault_config_service_registration
    hashicorp_vault_config_storage
    hashicorp_vault_config_template
  )
  platform 'centos'

  context 'create service registration HCL configuration' do
    recipe do
      hashicorp_vault_config_auto_auth 'aws' do
        type 'method'
        options(
          'mount_path' => 'auth/aws-subaccount',
          'config' => {
            'type' => 'iam',
            'role' => 'foobar',
          }
        )
      end

      hashicorp_vault_config_auto_auth 'file' do
        type 'sink'
        options(
          'wrap_ttl' => '5m',
          'aad_env_var' => 'TEST_AAD_ENV',
          'dh_type' => 'curve25519',
          'dh_path' => '/tmp/file-foo-dhpath2',
          'config' => {
            'path' => '/tmp/file-bar',
          }
        )
      end

      hashicorp_vault_config_entropy 'seal' do
        type 'seal'
        options(
          'mode' => 'augmentation'
        )
      end

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

      hashicorp_vault_config_seal 'awskms' do
        type 'awskms'
        options(
          'region' => 'us-east-1',
          'access_key' => 'AKIAIOSFODNN7EXAMPLE',
          'secret_key' => 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
          'kms_key_id' => '19ec80b0-dfdd-4d97-8164-c6examplekey',
          'endpoint' => 'https://vpce-0e1bb1852241f8cc6-pzi0do8n.kms.us-east-1.vpce.amazonaws.com'
        )
      end

      hashicorp_vault_config_service_registration 'kubernetes' do
        type 'kubernetes'
        options(
          'namespace' => 'my-namespace',
          'pod_name' => 'my-pod-name'
        )
      end

      hashicorp_vault_config_storage '/opt/vault/data' do
        type 'file'
        options(
          'path' => '/opt/vault/data'
        )
      end

      hashicorp_vault_config_storage 'inmem test' do
        type 'inmem'
      end

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

    it 'Creates the auto_auth configuration correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# auto_auth/)
        .with_content(%r{  mount_path = "auth\/aws-subaccount"})
        .with_content(/      type = "iam"/)
        .with_content(/# auto_auth/)
        .with_content(/  dh_type = "curve25519"/)
        .with_content(%r{      path = "\/tmp\/file-bar"})
    end

    it 'Creates the entropy configuration correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# entropy/)
        .with_content(/entropy "seal" {/)
        .with_content(/  mode = "augmentation"/)
    end

    it 'Creates the listener configuration correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# listener/)
        .with_content(/listener "tcp" {/)
        .with_content(/  cluster_address = "127.0.0.1:8201"/)
        .with_content(/    unauthenticated_metrics_access = false/)
    end

    it 'Creates the seal configuration correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# seal/)
        .with_content(/seal "awskms" {/)
        .with_content(/  region = "us-east-1"/)
        .with_content(%r{  endpoint = "https:\/\/vpce-0e1bb1852241f8cc6-pzi0do8n.kms.us-east-1.vpce.amazonaws.com"})
    end

    it 'Creates the service_registration configuration correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# service_registration/)
        .with_content(/service_registration "kubernetes" {/)
        .with_content(/  namespace = "my-namespace"/)
        .with_content(/  pod_name = "my-pod-name"/)
    end

    it 'Creates the storage configuration correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# storage/)
        .with_content(/storage "file" {/)
        .with_content(%r{  path = "\/opt\/vault\/data"})
        .with_content(/# storage/)
        .with_content(/storage "inmem" {/)
    end

    it 'Creates the templateage configuration correctly' do
      is_expected.to render_file('/etc/vault.d/vault.hcl')
        .with_content(/# template/)
        .with_content(/template {/)
        .with_content(%r{  source = "/etc/vault/server.key.ctmpl"})
        .with_content(%r{  destination = "/etc/vault/server.key"})
        .with_content(%r{  source = "/etc/vault/server.crt.ctmpl"})
        .with_content(%r{  destination = "/etc/vault/server.crt"})
    end
  end
end
