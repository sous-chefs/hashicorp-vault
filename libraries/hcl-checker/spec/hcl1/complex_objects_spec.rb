RSpec.describe HCL::Checker do
  context 'list of complex objects ' do
    it 'accepts a list with object elements' do
      hcl_string = %(
        module "foo" {
          bar = [{
            enabled = true
          },
          {
            enabled = false
          }
          ]
        }
      )

      ret = HCL::Checker.parse hcl_string
      expect(ret).to eq({
                          'module' => {
                            'foo' => {
                              'bar' => [
                                { 'enabled' => true },
                                { 'enabled' => false }
                              ]
                            }
                          }
                        })
    end

    it 'accepts a list with array elements' do
      hcl_string = %(
        module "foo" {
          bar = [ [ 1, 2, 3 ] ]
        }
      )

      ret = HCL::Checker.parse hcl_string
      expect(ret).to eq({ 'module' => { 'foo' => { 'bar' => [[1, 2, 3]] } } })
    end

    it 'accepts multiples of common type hcl elements' do
      hcl_string = %(
        template {
          source = "/etc/vault/server.key.ctmpl"
          destination = "/etc/vault/server.key"
        }
        template {
          source = "/etc/vault/server.crt.ctmpl"
          destination = "/etc/vault/server.crt"
        }
      )

      ret = HCL::Checker.parse hcl_string
      expect(ret).to eq({ 'template' => [{ 'source' => '/etc/vault/server.key.ctmpl', 'destination' => '/etc/vault/server.key' },
                                         { 'source' => '/etc/vault/server.crt.ctmpl',
                                           'destination' => '/etc/vault/server.crt' }] })
    end

    it 'accepts multiples of common type hcl elements nested' do
      hcl_string = %(
        auto_auth {
          method "aws" {
            mount_path = "auth/aws-subaccount"
            config = {
              type = "iam"
              role = "foobar"
            }
          }
          sink "file" {
            config = {
              path = "/tmp/file-foo"
            }
          }
          sink "file" {
            wrap_ttl = "5m"
            aad_env_var = "TEST_AAD_ENV"
            dh_type = "curve25519"
            dh_path = "/tmp/file-foo-dhpath2"
            config = {
              path = "/tmp/file-bar"
            }
          }
        }
      )

      ret = HCL::Checker.parse hcl_string
      expect(ret).to eq({
                          'auto_auth' =>
                            { 'method' => { 'aws' => { 'mount_path' => 'auth/aws-subaccount', 'config' => { 'type' => 'iam', 'role' => 'foobar' } } },
                              'sink' => [
                                { 'file' => { 'config' => { 'path' => '/tmp/file-foo' } } },
                                { 'file' => { 'wrap_ttl' => '5m', 'aad_env_var' => 'TEST_AAD_ENV', 'dh_type' => 'curve25519',
                                              'dh_path' => '/tmp/file-foo-dhpath2', 'config' => { 'path' => '/tmp/file-bar' } } }
                              ] }
                        })
    end
  end

  context 'with empty file' do
    hcl_string = ''
    it('should parse') { expect(HCL::Checker.valid?(hcl_string)).to eq(true) }
  end
end
