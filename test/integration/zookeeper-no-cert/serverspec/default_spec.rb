require 'spec_helper'

describe file('/home/vault/.vault.json') do
  describe '#content' do
    subject { super().content }
    it { is_expected.to include '"tls_disable": 1' }
    it { is_expected.to match %r("zookeeper": {\s+"advertise_addr": "http://localhost:8200") }
  end
end

describe service('vault') do
  it { is_expected.to be_enabled }
  it { is_expected.to be_running }
end

describe file('/etc/vault/ssl/certs/vault.crt') do
  it { is_expected.to_not be_file }
end

describe file('/etc/vault/ssl/private/vault.key') do
  it { is_expected.to_not be_file }
end
