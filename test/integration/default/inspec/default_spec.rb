describe file('/opt/vault/1.0.0/vault') do
  it { should be_file }
  it { should be_executable }
end

describe group('vault') do
  it { should exist }
end

describe user('vault') do
  it { should exist }
end

describe file('/etc/vault/vault.json') do
  its('mode') { should eq 0640 }
  it { should be_file }
  it { should be_owned_by 'vault' }
  it { should be_grouped_into 'vault' }
end

describe service('vault') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe json('/etc/vault/vault.json') do
  its("ui") { should be_in [true] }
  its("disable_performance_standby") { should be_in [true] }
end
