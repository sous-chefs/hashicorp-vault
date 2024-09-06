name 'default'
default_source :supermarket
default_source :chef_repo, '..'
cookbook 'hashicorp-vault', path: '../../..'
cookbook 'mingw', '2.1.1'
run_list 'hashicorp-vault::default'
