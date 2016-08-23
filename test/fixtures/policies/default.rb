name 'default'
default_source :community
default_source :chef_repo, '..'
cookbook 'hashicorp-vault', path: '../../..'
run_list 'hashicorp-vault::default'
named_run_list :centos, 'sudo::default', 'yum::default', run_list
named_run_list :debian, 'apt::default', run_list
named_run_list :freebsd, 'freebsd::default', run_list
named_run_list :windows, 'windows::default', run_list

default['authorization']['sudo']['users'] = %w(kitchen vagrant)
