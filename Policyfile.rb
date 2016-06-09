name 'vault'
default_source :community
cookbook 'hashicorp-vault', path: '.'
run_list 'hashicorp-vault::default'
named_run_list :debian, 'apt::default', run_list
named_run_list :ubuntu, 'ubuntu::default', run_list
named_run_list :redhat, 'redhat::default', run_list
