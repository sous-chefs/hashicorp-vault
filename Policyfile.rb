# frozen_string_literal: true

name 'hashicorp-vault'

default_source :supermarket

run_list 'recipe[test::server_json]'

cookbook 'hashicorp-vault', path: '.'
cookbook 'test', path: './test/cookbooks/test'

named_run_list :server_json, 'recipe[test::server_json]'
named_run_list :server_hcl, 'recipe[test::server_hcl]'
named_run_list :server_hcl_ark, 'recipe[test::server_hcl_ark]'
named_run_list :agent_json, 'recipe[test::agent_json]'
named_run_list :agent_hcl, 'recipe[test::agent_hcl]'
