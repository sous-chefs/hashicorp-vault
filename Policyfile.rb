name 'vault'
default_source :community
cookbook 'vault', path: '.'
run_list 'vault::default'
