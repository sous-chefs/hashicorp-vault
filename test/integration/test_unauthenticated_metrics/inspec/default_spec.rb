describe file('/opt/vault/1.8.4/vault') do
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
  its('content') { should match /.*log_level.*/ }
  its('content') { should match /.*unauthenticated_metrics_access": true.*/}
end

describe service('vault') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
