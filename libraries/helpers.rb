
module Vault
  module Cookbook
    module Helpers
      def vault_source(version)
        case node['platform_family']
        when 'debian', 'rhel', 'suse'
          platform = 'linux'
        when 'windows'
          platform = 'windows'
        when 'mac_os_x'
          platform = 'darwin'
        end
        "https://releases.hashicorp.com/vault/#{version}/vault_#{version}_#{platform}_amd64.zip"
      end
    end
  end
end
