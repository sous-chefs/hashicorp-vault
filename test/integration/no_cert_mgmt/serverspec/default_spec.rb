require 'spec_helper'

describe file('/etc/vault/ssl/certs/vault.crt') do
  it { is_expected.to_not be_file }
end

describe file('/etc/vault/ssl/private/vault.key') do
  it { is_expected.to_not be_file }
end
