describe json('/etc/vault/vault.json') do
  its(%w(seal awskms region)) { should eq 'us-west-2' }
  its(%w(seal awskms kms_key_id)) { should eq 'my-kms-id' }
end
