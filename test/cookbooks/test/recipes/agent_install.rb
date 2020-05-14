hashicorp_vault_agent_template '/tmp/test' do
  contents 'pie'
end

hashicorp_vault_agent_install 'package' do
  auto_auth_method 'approle'
  auto_auth_method_config(
    'role_id_file_path': '/tmp/test-role-id',
    'secret_id_file_path': '/tmp/test-secret-id'
  )
end
