name 'vault'
run_list 'vault::default'
default_source :community
cookbook 'vault', path: '.'
