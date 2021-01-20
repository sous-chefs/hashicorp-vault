describe package('vault') do
  it { should be_installed }
end

describe group('vault') do
  it { should exist }
end

describe user('vault') do
  it { should exist }
end

describe file('/etc/vault.d/vault.json') do
  it { should be_file }
  its('owner') { should eq 'vault' }
  its('group') { should eq 'vault' }
  its('mode') { should cmp '0640' }
end

describe file('/etc/systemd/system/vault.service') do
  it { should be_file }
end

describe service('vault') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe json('/etc/vault.d/vault.json') do
  its('ui') { should be_in [true] }
  its('disable_performance_standby') { should be_in [true] }
end
