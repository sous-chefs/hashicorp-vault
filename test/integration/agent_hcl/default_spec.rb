describe package('vault') do
  it { should be_installed }
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
  its('content') { should match %r{pid_file = \"\./pidfile\"} }
  its('content') { should match /use_auto_auth_token = true/ }
end

describe file('/etc/systemd/system/vault-agent.service') do
  it { should be_file }
end

describe service('vault-agent') do
  it { should be_installed }
  it { should be_enabled }
end
