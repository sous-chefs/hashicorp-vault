require 'spec_helper'

describe command('which vault') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match '/usr/local/bin/vault' }
end

describe group('vault') do
  it { should exist }
end

describe user('vault') do
  it { should exist }
end

describe file('/etc/vault.json') do
  it { should be_file }
  it { should be_mode '0644' }
end

describe service('vault') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/ssl/certs/vault.cert') do
  its(:content) { should match 'foo' }
  it { should be_file }
  it { should be_owned_by('vault') }
  it { should be_grouped_into('vault') }
  it { should be_mode('0644') }
end

describe file('/etc/ssl/private/vault.pem') do
  its(:content) { should match 'bar' }
  it { should be_file }
  it { should be_owned_by('vault') }
  it { should be_grouped_into('vault') }
  it { should be_mode('0640') }
end
