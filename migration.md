# Upgrading to version 7

The cookbook provides custom resources. Root recipes and node attributes are not part of its API. Configure each resource explicitly in a wrapper cookbook.

Supported systems now start at Debian 12, Ubuntu 22.04, Amazon Linux 2023, CentOS Stream 9, RHEL-family 8 and openSUSE Leap 16. Upgrade obsolete operating systems before applying this release.

Use `install_method :ark` with an explicit version on Fedora or openSUSE. HashiCorp does not provide matching package repositories for these current platforms. Other supported systems can continue using repository installation.

```ruby
hashicorp_vault_install 'vault' do
  install_method :ark
  version '1.6.1'
end

hashicorp_vault_config_global 'vault' do
  ui true
end

hashicorp_vault_service 'vault' do
  vault_binary_path '/usr/local/bin/vault'
  action [:create, :enable, :start]
end
```

Pin a release and its checksum appropriate for your deployment. The example uses the existing integration fixture version; it is not a recommendation for a new production deployment. Add a listener and storage resource before starting a production server.
