describe file('/opt/vault/1.8.5/vault') do
  it { should be_file }
  it { should be_executable }
end

describe file('/var/log/vault') do
  it { should be_directory }
  it { should be_owned_by 'vault' }
  it { should be_grouped_into 'vault' }
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
  its('content') { should match /.*log_level.*/ }
  its('content') { should match /.*reporting.*/ }
end

describe service('vault') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
