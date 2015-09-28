name 'vault'
run_list 'vault::default'
default_source :community
cookbook 'vault', path: '.'
cookbook 'chef-vault', git: 'https://github.com/chef-cookbooks/chef-vault'
