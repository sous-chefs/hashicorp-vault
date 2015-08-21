require 'spec_helper'

describe command('which vault') do
  its(:exit_status) { is_expected.to eq 0 }
  its(:stdout) { is_expected.to match '/usr/local/bin/vault' }
end

describe group('vault') do
  it { is_expected.to exist }
end

describe user('vault') do
  it { is_expected.to exist }
end

describe file('/home/vault/.vault.json') do
  it { is_expected.to be_file }
  it { is_expected.to be_mode 640 }
  it { is_expected.to be_owned_by('vault') }
  it { is_expected.to be_grouped_into('vault') }
end

describe service('vault') do
  it { is_expected.to be_enabled }
  it { is_expected.to be_running }
end

describe file('/etc/ssl/certs/vault.crt') do
  it { is_expected.to be_file }
  it { is_expected.to be_owned_by('vault') }
  it { is_expected.to be_grouped_into('vault') }
  it { is_expected.to be_mode 644 }
  describe '#content' do
    subject { super().content }
    it { is_expected.to include '-----BEGIN CERTIFICATE-----' }
    it { is_expected.to include '-----END CERTIFICATE-----' }
  end
end

describe file('/etc/ssl/private/vault.key') do
  it { is_expected.to be_file }
  it { is_expected.to be_owned_by('vault') }
  it { is_expected.to be_grouped_into('vault') }
  it { is_expected.to be_mode 640 }
  describe '#content' do
    subject { super().content }
    it { is_expected.to include '-----BEGIN RSA PRIVATE KEY-----' }
    it { is_expected.to include '-----END RSA PRIVATE KEY-----' }
  end
end
