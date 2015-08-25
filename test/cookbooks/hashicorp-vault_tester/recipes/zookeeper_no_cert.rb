
node.set['vault']['config']['listener']['tcp']['tls_disable'] = 1
node.set['vault']['config']['backend'] = {
  zookeeper: {
    advertise_addr: 'http://localhost:8200'
  }
}

include_recipe 'zookeeper::default'
include_recipe 'zookeeper::service'
include_recipe 'hashicorp-vault::default'
