hashicorp_vault_install 'package' do
  ui true
  disable_performance_standby true
  tls_disable true
  action [:install]
end
