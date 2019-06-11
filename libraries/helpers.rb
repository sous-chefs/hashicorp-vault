#
# Cookbook: vault
# License: Apache 2.0
#
# Copyright 2014-2018, Bloomberg Finance L.P.
#

module VaultCookbook
  module Helpers
    extend self # rubocop:disable Style/ModuleFunction

    def arch_64?
      node['kernel']['machine'] =~ /x86_64/ ? true : false
    end

    def windows?
      node['os'].eql?('windows') ? true : false
    end

    # returns windows friendly version of the provided path,
    # ensures backslashes are used everywhere
    # Gently plucked from https://github.com/chef-cookbooks/windows
    def win_friendly_path(path)
      path.gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR || '\\') if path
    end

    # Simply using ::File.join was causing several attributes
    # to return strange values in the resources (e.g. "C:/Program Files/\\vault\\data")
    def join_path(*path)
      windows? ? win_friendly_path(::File.join(path)) : ::File.join(path)
    end

    def program_files
      join_path('C:', 'Program Files') + (arch_64? ? '' : ' x(86)')
    end

    def vault_config_prefix_path
      windows? ? join_path(program_files, 'vault') : join_path('/etc', 'vault')
    end

    def vault_data_path
      windows? ? join_path(program_files, 'vault', 'data') : join_path('/var/lib', 'vault')
    end
  end
end

Chef::Node.send(:include, VaultCookbook::Helpers)
