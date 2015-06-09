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
