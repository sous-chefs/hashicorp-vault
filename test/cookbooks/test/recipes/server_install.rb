hashicorp_vault_install "package" do
  ui true
  disable_performance_standby true
  action [:install]
end
