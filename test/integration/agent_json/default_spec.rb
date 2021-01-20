describe package('vault') do
  it { should be_installed }
end

describe group('vault') do
  it { should exist }
end

describe user('vault') do
  it { should exist }
end

describe file('/etc/vault.d/vault-agent.json') do
  it { should be_file }
  its('owner') { should eq 'vault' }
  its('group') { should eq 'vault' }
  its('mode') { should cmp '0640' }
end

describe file('/etc/systemd/system/vault-agent.service') do
  it { should be_file }
end

describe service('vault-agent') do
  it { should be_installed }
  it { should be_enabled }
end

describe json('/etc/vault.d/vault-agent.json') do
  its('pid_file') { should eq './pidfile' }
  its(%w(cache use_auto_auth_token)) { should eq true }
end
