module Vault
  module Cookbook
    module InstallHelpers
      def vault_source(version)
        platform = case node['platform_family']
                   when 'debian', 'rhel', 'suse', 'fedora', 'amazon'
                     'linux'
                   when 'windows'
                     'windows'
                   when 'mac_os_x'
                     'darwin'
                   else
                     raise ArgumentError, "vault_source: Unsupported platform family #{node['platform_family']}"
                   end

        arch =  case node['kernel']['machine']
                when 'aarch64'
                  'arm64'
                when 'i386'
                  '386'
                else
                  'amd64'
                end

        "https://releases.hashicorp.com/vault/#{version}/vault_#{version}_#{platform}_#{arch}.zip"
      end

      def vault_supporting_packages
        pkg = %w(unzip rsync)
        pkg.push('libcap2-bin') if platform_family?('debian')

        pkg
      end

      def vault_repo_platform
        case node['platform_family']
        when 'rhel'
          'RHEL'
        when 'fedora'
          'fedora'
        when 'amazon'
          'AmazonLinux'
        when 'debian'
          require 'mixlib/shellout'

          lsb_command = Mixlib::ShellOut.new('lsb_release -cs')
          lsb_command.run_command
          lsb_command.error!

          lsb_command.stdout.delete("\n")
        else
          raise ArgumentError, "vault_repo_platform: Unsupported platform family #{node['platform_family']}"
        end
      end
    end
  end
end
