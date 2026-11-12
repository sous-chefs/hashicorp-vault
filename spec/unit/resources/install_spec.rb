# frozen_string_literal: true

require 'spec_helper'

describe 'hashicorp_vault_install' do
  step_into :hashicorp_vault_install
  platform 'centos'

  context 'install vault' do
    recipe do
      hashicorp_vault_install 'package'
    end

    describe 'creates repo and installs vault' do
      it { is_expected.to create_yum_repository('hashicorp') }
      it { is_expected.to create_yum_repository('hashicorp-test') }
      it { is_expected.to install_package('vault') }
    end
  end

  context 'Amazon Linux 2023 vendor repository' do
    platform 'amazon', '2023'

    recipe do
      hashicorp_vault_install 'package'
    end

    it do
      is_expected.to create_yum_repository('hashicorp').with(
        baseurl: 'https://rpm.releases.hashicorp.com/AmazonLinux/latest/$basearch/stable'
      )
    end
  end

  context 'ARM64 Ubuntu repository' do
    platform 'ubuntu', '24.04'
    automatic_attributes['kernel']['machine'] = 'aarch64'

    recipe do
      hashicorp_vault_install 'package'
    end

    it { is_expected.to add_apt_repository('hashicorp').with(arch: 'arm64', distribution: 'noble') }
  end

  context 'remove an ARK installation' do
    recipe do
      hashicorp_vault_install 'binary' do
        install_method :ark
        version '1.6.1'
        action :remove
      end
    end

    it { is_expected.to delete_link('/usr/local/bin/vault') }
    it { is_expected.to delete_link('/usr/local/vault') }
    it { is_expected.to delete_directory('/opt/vault/vault-1.6.1') }
    it { is_expected.to delete_file(File.join(Chef::Config[:file_cache_path], 'vault-1.6.1.zip')) }
    it { is_expected.not_to remove_user('vault') }
    it { is_expected.not_to remove_group('vault') }
  end

  context 'SUSE binary installation capabilities' do
    platform 'opensuse', '16.0'

    recipe do
      hashicorp_vault_install 'binary' do
        install_method :ark
        version '1.6.1'
      end
    end

    before do
      stub_command('setcap -v cap_ipc_lock+ep $(readlink -f /usr/local/bin/vault)').and_return(true)
    end

    it { is_expected.to install_package(%w(unzip rsync libcap-progs)) }
  end
end
