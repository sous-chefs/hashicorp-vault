# frozen_string_literal: true

name              'hashicorp-vault'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Application cookbook for installing and configuring Vault.'
issues_url        'https://github.com/sous-chefs/hashicorp-vault/issues'
source_url        'https://github.com/sous-chefs/hashicorp-vault'
chef_version      '>= 16'
version           '7.0.0'

supports 'almalinux', '>= 8.0'
supports 'amazon', '>= 2023.0'
supports 'centos_stream', '>= 9.0'
supports 'debian', '>= 12.0'
supports 'fedora', '>= 43.0'
supports 'opensuseleap', '>= 16.0'
supports 'oracle', '>= 8.0'
supports 'redhat', '>= 8.0'
supports 'rocky', '>= 8.0'
supports 'suse', '>= 15.0'
supports 'ubuntu', '>= 22.04'

depends 'ark', '~> 6.0'

gem 'hcl-checker', '~> 1.6'
