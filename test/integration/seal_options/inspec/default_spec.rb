describe json('/etc/vault/vault.json') do
  its(['seal', 'awskms', 'region']) { should eq 'us-west-2' }
  its(['seal', 'awskms', 'kms_key_id']) { should eq 'my-kms-id' }
end
