require 'spec_helper'

describe file('/opt/vault/0.5.1/vault') do
  it { should be_file }
  it { should be_executable }
end

describe group('vault') do
  it { is_expected.to exist }
end

describe user('vault') do
  it { is_expected.to exist }
end

describe file('/etc/vault/vault.json') do
  it { is_expected.to be_file }
  it { is_expected.to be_mode 640 }
  it { is_expected.to be_owned_by('vault') }
  it { is_expected.to be_grouped_into('vault') }
end

describe service('vault') do
  it { is_expected.to be_enabled }
  it { is_expected.to be_running }
end
