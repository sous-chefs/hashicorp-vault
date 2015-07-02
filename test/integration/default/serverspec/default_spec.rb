require 'spec_helper'

describe command('/usr/local/bin/vault -v') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'Vault v0.1.2' }
end

describe group('vault') do
  it { should exist }
end

describe user('vault') do
  it { should exist }
end

describe file('/home/vault/.vault.json') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by('vault') }
  it { should be_grouped_into('vault') }
end

describe service('vault') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8200) do
  it { should be_listening }
end

describe file('/etc/vault/ssl/certs/vault.crt') do
  it { should contain '-----BEGIN CERTIFICATE-----' }
  it { should contain '-----END CERTIFICATE-----' }
  it { should be_file }
  it { should be_owned_by('vault') }
  it { should be_grouped_into('vault') }
  it { should be_mode 644 }
end

describe file('/etc/vault/ssl/private/vault.key') do
  it { should contain '-----BEGIN RSA PRIVATE KEY-----' }
  it { should contain '-----END RSA PRIVATE KEY-----' }
  it { should be_file }
  it { should be_owned_by('vault') }
  it { should be_grouped_into('vault') }
  it { should be_mode 640 }
end
