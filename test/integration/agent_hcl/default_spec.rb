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
  its('content') { should match /log_level = \"info\"/ }
  its('content') { should match /use_auto_auth_token = true/ }
end

describe file('/etc/systemd/system/vault-agent.service') do
  it { should be_file }
  its('content') { should match %r{ConditionFileNotEmpty=\/etc\/vault.d\/vault.hcl} }
  its('content') { should match %r{ExecStart=\/usr\/bin\/vault agent -config=\/etc\/vault.d\/vault.hcl} }
end

describe service('vault-agent') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
