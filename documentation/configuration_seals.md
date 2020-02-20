# Seal Configurations

<!-- TODO: Document Seal values -->

## [AliCloud KMS](https://www.vaultproject.io/docs/configuration/seal/alicloudkms.html)

The AliCloud KMS seal configures Vault to use AliCloud KMS as the seal wrapping mechanism.

```ruby
seal_type = 'alicloudkms'
seal_options = {
  region: 'us-east-1',
  access_key: '0wNEpMMlzy7szvai',
  secret_key: 'PupkTg8jdmau1cXxYacgE736PJj4cA',
  kms_key_id: '08c33a6f-4e0a-4a1b-a3fa-7ddfa1d4fb73',
}
```

## [AWS KMS](https://www.vaultproject.io/docs/configuration/seal/awskms.html)

The AWS KMS seal configures Vault to use AWS KMS as the seal wrapping mechanism.

```ruby
seal_type 'awskms'
seal_options {
  region: 'us-east-1',
  access_key: 'AKIAIOSFODNN7EXAMPLE',
  secret_key: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
  kms_key_id: '19ec80b0-dfdd-4d97-8164-c6examplekey',
  endpoint: 'https://vpce-0e1bb1852241f8cc6-pzi0do8n.kms.us-east-1.vpce.amazonaws.com',
}
```

## [Azure Key Vault](https://www.vaultproject.io/docs/configuration/seal/azurekeyvault.html)

The Azure Key Vault seal configures Vault to use Azure Key Vault as the seal wrapping mechanism.

```ruby
seal_type 'azurekeyvault',
seal_options {
  tenant_id: '46646709-b63e-4747-be42-516edeaf1e14',
  client_id: '03dc33fc-16d9-4b77-8152-3ec568f8af6e',
  client_secret: 'DUJDS3...',
  vault_name: 'hc-vault',
  key_name: 'vault_key',
}
```

## [GCP Cloud KMS](https://www.vaultproject.io/docs/configuration/seal/gcpckms.html)

The GCP Cloud KMS seal configures Vault to use GCP Cloud KMS as the seal wrapping mechanism.

```ruby
seal_type 'gcpckms'
seal_options  {
  credentials: '/usr/vault/vault-project-user-creds.json',
  project: 'vault-project',
  region: 'global',
  key_ring: 'vault-keyring',
  crypto_key: 'vault-key',
}
```

## [HSM PKCS11 (ENT)](https://www.vaultproject.io/docs/configuration/seal/pkcs11.html)

The PKCS11 seal configures Vault to use an HSM with PKCS11 as the seal wrapping mechanism.

```ruby
seal_type 'pkcs11'
seal_options {
  lib: '/usr/vault/lib/libCryptoki2_64.so',
  slot: '0',
  pin: 'AAAA-BBBB-CCCC-DDDD',
  key_label: 'vault-hsm-key',
  hmac_key_label: 'vault-hsm-hmac-key',
}
```

## [Vault Transit](https://www.vaultproject.io/docs/configuration/seal/transit.html)

The Transit seal configures Vault to use Vault's Transit Secret Engine as the autoseal mechanism.

```ruby
seal_type 'transit'
seal_options {
  address: 'https://vault:8200',
  token: 's.Qf1s5zigZ4OX6akYjQXJC1jY',
  disable_renewal: 'false',
  key_name: 'transit_key_name',
  mount_path: 'transit/',
  namespace: 'ns1/',
  tls_ca_cert: '/etc/vault/ca_cert.pem',
  tls_client_cert: '/etc/vault/client_cert.pem',
  tls_client_key: '/etc/vault/ca_cert.pem',
  tls_server_name: 'vault',
  tls_skip_verify: 'false',
}
```
