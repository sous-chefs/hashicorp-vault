describe file('/opt/vault/0.9.4/vault') do
  it { should be_file }
  it { should be_executable }
end

describe group('vault') do
  it { should exist }
end

describe user('vault') do
  it { should exist }
end

%w(/opt/vault /opt/vault/0.6.5).each do |path|
  describe directory(path) do
    it { should exist }
    its('mode') { should cmp '0755' }
  end
end

describe directory('/etc/vault') do
  it { should exist }
  its('owner') { should eq 'vault' }
  its('group') { should eq 'vault' }
  its('mode') { should cmp '0750' }
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
