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
  it { should_not exist }
end

describe file('/etc/vault.d/config_global_vault.hcl') do
  it { should be_file }
  its('owner') { should eq 'vault' }
  its('group') { should eq 'vault' }
  its('mode') { should cmp '0640' }
  its('content') { should match /ui = true/ }
  its('content') { should match /disable_performance_standby = true/ }
end

describe file('/etc/vault.d/config_listener_tcp.hcl') do
  it { should be_file }
  its('owner') { should eq 'vault' }
  its('group') { should eq 'vault' }
  its('mode') { should cmp '0640' }
  its('content') { should match /# Test TCP listener/ }
  its('content') { should match /listener "tcp" {/ }
  its('content') { should match /address = "127.0.0.1:8200"/ }
  its('content') { should match /unauthenticated_metrics_access = false/ }
end

describe file('/etc/vault.d/config_storage_file.hcl') do
  it { should be_file }
  its('owner') { should eq 'vault' }
  its('group') { should eq 'vault' }
  its('mode') { should cmp '0640' }
  its('content') { should match /# Test file storage/ }
  its('content') { should match /storage "file" {/ }
  its('content') { should match %r{path = "/opt/vault/data"} }
end

describe file('/etc/systemd/system/vault.service') do
  it { should be_file }
  its('content') { should match %r{ConditionPathIsDirectory = \/etc\/vault.d} }
  its('content') { should match %r{ExecStart = \/usr\/bin\/vault server -config=\/etc\/vault.d} }
end

describe service('vault') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
