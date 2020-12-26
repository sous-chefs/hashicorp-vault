# hashicorp_vault_install 'package' do
#   ui true
#   disable_performance_standby true
#   tls_disable true
#   sensitive true
#   action [:install]
# end

hashicorp_vault_install 'package' do
  action :upgrade
end
