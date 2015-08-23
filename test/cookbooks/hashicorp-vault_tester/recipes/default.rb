
node.set['vault']['config']['backend'] = { inmem: {} }

include_recipe 'zookeeper::default'
include_recipe 'zookeeper::service'
include_recipe 'hashicorp-vault::default'
