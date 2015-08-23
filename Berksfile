source 'https://supermarket.chef.io'

metadata

cookbook 'chef-vault', github: 'chef-cookbooks/chef-vault', ref: '902a089'

group :integration do
  cookbook 'zookeeper', '~> 2.0'
  cookbook 'runit', github: 'hw-cookbooks/runit', ref: 'ee15ff5'
  cookbook 'hashicorp-vault_tester', path: 'test/cookbooks/hashicorp-vault_tester'
end
