name 'default'
default_source :supermarket
default_source :chef_repo, '..'
cookbook 'hashicorp-vault', path: '../../..'
run_list 'hashicorp-vault::default'
