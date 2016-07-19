name 'default'
default_source :community
cookbook 'hashicorp-vault', path: '.'
run_list 'hashicorp-vault::default'
