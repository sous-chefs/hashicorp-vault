#
# Cookbook: hashicorp-vault-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#

vault_service node['vault']['service_name'] do
  user node['vault']['service_user']
  group node['vault']['service_group']
end
