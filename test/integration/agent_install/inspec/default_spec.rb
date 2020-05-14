describe file('/opt/vault/vault-1.4.1/vault') do
  it { should be_file }
  it { should be_executable }
end

describe group('vault') do
  it { should exist }
end

describe user('vault') do
  it { should exist }
end

describe file('/etc/vault/agent.json') do
  its('mode') { should eq 0640 }
  it { should be_file }
  it { should be_owned_by 'vault' }
  it { should be_grouped_into 'vault' }
end

describe file('/etc/systemd/system/vault-agent.service') do
  it { should be_file }
end

describe service('vault-agent') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe json('/etc/vault/agent.json') do
  its('exit_after_auth') { should be_in [false] }
  its('pid_file') { should eq './pidfile' }
  its(['auto_auth', 'method', 'type']) { should eq 'approle' }
end
