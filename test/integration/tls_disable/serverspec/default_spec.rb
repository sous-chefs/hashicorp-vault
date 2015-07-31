require 'spec_helper'

describe file('/home/vault/.vault.json') do
  describe '#content' do
    subject { super().content }
    it { is_expected.to include '"tls_disable": "1"' }
  end
end

describe file('/etc/vault/ssl/certs/vault.crt') do
  it { is_expected.to_not be_file }
end

describe file('/etc/vault/ssl/private/vault.key') do
  it { is_expected.to_not be_file }
end
