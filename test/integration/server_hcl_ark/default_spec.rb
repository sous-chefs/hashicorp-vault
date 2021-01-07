describe file('/opt/vault/vault-1.6.1/vault') do
  it { should be_file }
  it { should be_executable }
end

describe file('/usr/local/bin/vault') do
  it { should be_symlink }
  it { should be_file }
  it { should_not be_directory }
  it { should be_executable }
end

describe group('vault') do
  it { should exist }
end

describe user('vault') do
  it { should exist }
end

describe file('/etc/vault.d/vault.hcl') do
  it { should be_file }
  its('owner') { should eq 'vault' }
  its('group') { should eq 'vault' }
  its('mode') { should cmp '0640' }
  its('content') { should match /ui = true/ }
  its('content') { should match /disable_performance_standby = true/ }
end

describe file('/etc/systemd/system/vault.service') do
  it { should be_file }
end

describe service('vault') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
