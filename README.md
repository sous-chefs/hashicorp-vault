# vault-cookbook
[![Build Status](https://img.shields.io/travis/johnbellone/vault-cookbook.svg)](https://travis-ci.org/johnbellone/vault-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/hashicorp-vault.svg)](https://supermarket.chef.io/cookbooks/hashicorp-vault)
[![Coverage](https://img.shields.io/codecov/c/github/johnbellone/vault-cookbook.svg)](https://codecov.io/github/johnbellone/vault-cookbook)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

[Application cookbook][0] for installing and configuring [Hashicorp Vault][1].

## Platforms Supported / Tested

* Ubuntu >= 12.04
* redhat >= 6.4
* centos >= 6.4

## Usage
### Attributes
For cookbook attributes you can refer derectly to the source code for the
most up to date attribute list. [Attributes](https://github.com/johnbellone/vault-cookbook/blob/master/attributes/default.rb)

### Basic Usage
For basic usage, you can get a vault server up and running quickly with most
of the defaults and rely on the `hashicorp-vault::default` recipe

This cookbook provides node attributes which are used to fine tune the default 
recipe which installs and configures Vault. These values are passed directly into the 
Chef resource/providers which are exposed for more advanced configuration.

### Advanced Usage
As mentioned above, attributes can be defined that get passed into the resource providers 
and alter the configuration of Vault.  This cookbook covers all the configuration options listed 
on the Vault configuration page [here](https://vaultproject.io/docs/config/index.html).
These attributes mirror what has been defined in the resource providers below and can be provided 
right off of the `node['vault']` attribute.  For instance to set a parameter for the vault\_config
 resource your parmeter would look like `node.default['vault']['config']['<property>'] = ` 
and for a vault\_server resource `node.default['vault']['server']['<property>'] =` 

Here are some examples of what it would look like to configure certain options in a wrapper cookbook

#### Change Vault listen address to 0.0.0.0
```
node.default['vault']['config']['address'] = '0.0.0.0:8200'

include_recipe 'hashicorp_vault::default'

```

#### Consul Backend
```
node.default['vault']['config']['backend_options']['address'] = '127.0.0.1:8500'
node.default['vault']['config']['backend_options']['path'] = 'vault'
node.default['vault']['config']['backend_options']['scheme'] = 'https'

include_recipe 'hashicorp_vault::default'
```

#### Install vault 0.1.2
```
node.default['vault']['server']['version'] = '0.1.2'

include_recipe 'hashicorp_vault::default'
```


### Resources/Providers
This cookbook provides resource and provider primitives to manage the
vault server server and configuration. These primitives are what is used in the
recipes, and should be used in your own wrapper cookbook should inclusion of the 
recipe not be sufficient.

#### vault\_config
| Parameter | Type | Description | Default |
| --------- | ---- | ----------- | ------- |
| path | String | Path for the vault configuration | '/home/vault/.vault.json' |
| owner | String | Owner for vault configuration file | 'vault' | 
| group | String | Group for the vault configuration file | 'vault' | 
| address | String | The address for vault to listen on | '127.0.0.1:8200' |
| tls\_disable | String | Whether to disable TLS | '' |
| tls\_key\_file | String | The key file to use with TLS | '/etc/vault/ssl/private/vault.key' |
| tls\_cert\_file | String | The cert file to use with TLS | '/etc/vault/ssl/certs/vault.crt' |
| bag\_name | String | The chef\_vault bag name to retrieve key/cert from | 'secrets' | 
| bag\_item | String | The chef\_vault bag item to retrieve key/cert from | 'vault' |
| disable\_mlock | Boolean | Whether to disable mlock | false |
| statsite\_addr | String | The optional statsite address for vault | |
| statsd\_addr | String | The optional statsd address for vault | |
| backend\_type | String | The backend\_type for vault to connect with | 'inmem' |
| backend\_options | Hash | The options associated with any backend\_type that is chosen | {} | 

```
vault_config '/home/vault/.vault.json' do
  owner 'vault'
  group 'vault'
  address '127.0.0.1:8200'
  tls_key_file '/etc/vault/ssl/private/vault.key'
  tls_cert_file '/etc/vault/ssl/certs/vault.crt' 
  bag_name 'secrets'
  bag_item 'vault'
  backend_type 'consul'
  backend_options { 
      'address' => '127.0.0.1:8500', 
      'path' => 'vault', 
      'scheme' => 'https' 
    }  
end
```


#### vault\_service
| Parameter | Type | Description | Default |
| --------- | ---- | ----------- | ------- |
| version   | String | Vault server version to install | 0.2.0 |
| install\_method | Symbol | Vault instsall method. Possible options: source, binary, package | binary |
| install\_path | String | Path to install vault | '/srv' |
| config\_path | String | Path for vault configuration file | '/home/vault/.vault.json' | 
| user | String | The user to manage the vault service | 'vault' |
| group | String | The group to manage the vault service | 'vault' | 
| environment | Hash | Environment variables to set in service definition | { PATH: '/usr/local/bin:/usr/bin:/bin' } |
| package\_name | String | The package name to install when package install\_method used | 'vault' |
| binary\_url | String | The binary url to use when binary install\_method used | "https://dl.bintray.com/mitchellh/vault/vault_%{version}.zip" |
| source\_url | String | The source url to use when source install\_method used | 'https://github.com/hashicorp/vault' |  

```
vault_service 'vault' do
  user 'vault'
  group 'vault'
  version '0.2.0'
  install_method 'binary'
  install_path '/srv/'
  config_path '/home/vault/.vault.json'
  environment { PATH: '/usr/local/bin:/usr/bin:/bin' }  
  binary_url 'https://dl.bintray.com/mitchellh/vault/vault_%{version}.zip'

  action [:create, :enable]
end
```

### Resources

[0]: http://blog.vialstudios.com/the-environment-cookbook-pattern/#thelibrarycookbook
[1]: https://www.vaultproject.io
