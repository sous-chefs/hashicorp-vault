#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright:: 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module VaultCookbook
  module Provider
    # A `vault_installation` provider which manages Vault binary
    # installation from remote source URL.
    # @action create
    # @action remove
    # @provides vault_installation
    # @example
    #   vault_installation '0.5.0'
    # @since 2.0
    class VaultInstallationBinary < Chef::Provider
      include Poise(inversion: :vault_installation)
      include ::VaultCookbook::Helpers
      provides(:binary)
      inversion_attribute('hashicorp-vault')

      # @api private
      def self.provides_auto?(_node, _resource)
        true
      end

      # Set the default inversion options.
      # @return [Hash]
      # @api private
      def self.default_inversion_options(node, new_resource)
        archive_basename = binary_basename(node, new_resource)
        super.merge(
          version: new_resource.version,
          archive_url: format(default_archive_url, version: new_resource.version, basename: archive_basename),
          archive_basename: archive_basename,
          archive_checksum: binary_checksum(node, new_resource),
          extract_to: '/opt/vault'
        )
      end

      def action_create
        notifying_block do
          directory ::File.join(options[:extract_to], new_resource.version) do
            recursive true
          end

          url = format(options[:archive_url], version: options[:version], basename: options[:archive_basename])
          poise_archive url do
            destination join_path(options[:extract_to], new_resource.version)
            source_properties checksum: options[:archive_checksum]
            strip_components 0
            not_if { ::File.exist?(vault_program) }
          end

          link '/usr/local/bin/vault' do
            to ::File.join(options[:extract_to], new_resource.version, 'vault')
          end
        end
      end

      def action_remove
        notifying_block do
          directory ::File.join(options[:extract_to], new_resource.version) do
            recursive true
            action :delete
          end

          link '/usr/local/bin/vault' do
            action :delete
            only_if 'test -L /usr/local/bin/vault'
          end
        end
      end

      def vault_program
        ::File.join(options[:extract_to], new_resource.version, 'vault')
      end

      def self.default_archive_url
        "https://releases.hashicorp.com/vault/%{version}/%{basename}" # rubocop:disable Style/StringLiterals
      end

      def self.binary_basename(node, resource)
        case node['kernel']['machine']
        when 'x86_64', 'amd64' then ['vault', resource.version, node['os'], 'amd64'].join('_')
        when 'i386' then ['vault', resource.version, node['os'], '386'].join('_')
        else ['vault', resource.version, node['os'], node['kernel']['machine']].join('_')
        end.concat('.zip')
      end

      def self.binary_checksum(node, resource)
        tag = node['kernel']['machine'] =~ /x86_64/ ? 'amd64' : node['kernel']['machine']
        case [node['os'], tag].join('-')
        when 'darwin-i386'
          case resource.version
          when '0.7.0' then '11d60c33e45ec842876ff7828eb1adf2abe97d1e845f92d7234013171d3a977e'
          when '0.7.1' then '1209a163aba27f3c1d7baaf08f0b04c1e11527d8d4b0d5b11b0f33503a19f2ca'
          when '0.7.2' then '1832fba41de86b551674addc87b591708456f68f3b4fe4daf007e08864e4a7ee'
          when '0.7.3' then '5ab070055bbcad9c59ab32d6f4479b432fcab0934fd4f251e1851bfb01b6487a'
          when '0.8.0' then '146d287faa8a397788189289acc54957f6899dadc83000d423651556f555b0c7'
          when '0.8.1' then 'ef835bb803ce45baab97fbe475e62f1124511190631923d4352d04c9e1cecce4'
          when '0.8.2' then '22e074ae2b7e43c5784b06c1a1c3b0d6a036972d362a5d7ace1cd82e4ad29687'
          when '0.8.3' then '774747c847be21a599e2e5ff44794397629cc9de19bbd324ffb3402c7574adba'
          when '0.9.0' then '32e132b860ca3cb024a184302d52473c57c3fb7b57df15f341a1b326494773d6'
          when '0.9.1' then '959b95e977882c09cb78c0457281e45b5c1910ccb14d71397f14ec9895a763ca'
          when '0.9.2' then 'c9be39e1564216f3e40c83e956229ee413fc21e82db870a6bd999d52dfdffc06'
          when '0.9.3' then '9e008c1724f982cc4ea6190e584d82649d964953de25dbd3ba50b57247fb6dcc'
          when '0.9.4' then 'f5f3a14c0a70680fcc8d8b7202d49f8533396ebf05d70356cd840094d082a438'
          end
        when 'darwin-amd64'
          case resource.version
          when '0.7.0' then 'db995adf0e46dd7ae43d2fa3523f44a007a6adc37c3a47de5c667a1361cffc13'
          when '0.7.1' then '9060e4e64b76b566b8ea4f5c76df605292c2aa184b6ec6c1e1fa1afe343e371d'
          when '0.7.2' then '1b29fabd094ab1afbb26ec6c3df3f7c3deef5ef408bb24db94ae07a330ab5317'
          when '0.7.3' then 'fa9badde19ba0bb9d7341ac0521593c09ea15a00ed824382c1f58855d2e0959c'
          when '0.8.0' then 'ae57608c662942bbcf00a05daad60df3f7f2d9f2d672b4e3490498c518704f20'
          when '0.8.1' then '8efa6ef642edf9fc48a6a7e2b0a24aec9b143369bca90add7724ddcf1e358ffd'
          when '0.8.2' then '55dd805fa96a0142b941b1e79c16cf02bd3555546ac51c26f8f307e91eeb966d'
          when '0.8.3' then '43c211d0a2ced793a25ac157cc4f3e2160ea9aa57f8d91f805a51e78a5b0b538'
          when '0.9.0' then '4ebe1cc96d89fa581ea14c87748b11aa6e54b8ef1fefca747159b9240c907207'
          when '0.9.1' then '16f318f46770fe229e9532912846f2d43c3877b4b9e8229d11920bdb90f92fd7'
          when '0.9.2' then 'd79adf8a12afe701eb8b2ad3aeb4b1a1c2ed6dd3a11c3b1aa0739c6fec229d90'
          when '0.9.3' then '9474cd8eb9207fea3de56ff86068fc4eb8d20ec7adf31cffb8b265633e659581'
          when '0.9.4' then '42772e82839423948e2230b164bda037c4c301581f642c72f93c384efc7735d8'
          end
        when 'freebsd-i386'
          case resource.version
          when '0.7.0' then 'd215da31431b91e5563152566f818a40df6ee2d07e2a43f5e2561edd95631caf'
          when '0.7.1' then 'ee6ee44973bb1262c17e77bf364d354fc3b2bf0c858acd49e1cd1ae57d7ff98f'
          when '0.7.2' then '3a3f9f0187b341718137d5f158387e69778b5862a6f874682ceded25208dd2a1'
          when '0.7.3' then '9de7796867266623bb4d9151be4d54ded62c0f63c93a32c490d5787589acdbfb'
          when '0.8.0' then '13b46c16b17b781375739162b662a87050e53e70081247b4c2a64da3c5b01788'
          when '0.8.1' then 'f05680e765f23d7887aa6c33ea552b52c6f0507377271c2adc45b59f7b6981a2'
          when '0.8.2' then '9563ad994614113467387734498ea116b8b20791f24c65f52c1cebc14dd97894'
          when '0.8.3' then 'fea69b39c78493ff03d8744473dc64ec4a95553d34383b138a82058e22c337c6'
          when '0.9.0' then '4a80a3b0b3b9aa9c3daaebbd2dd8c3618f443eaec93b6e34aa491a0992293c50'
          when '0.9.1' then 'c697bfbc3dbd72ff77b973d56aaa2d8475a035e62e185c15fa60c697b86749a9'
          when '0.9.2' then '57eef15eeed5cff9dd2718baef5633237f1a0b2d791c6df8e91ca99d9fa9c6a4'
          when '0.9.3' then 'a75e775e3b5453f14f223d518d59d3dcfbf1def3a201ce5709dcca438ea59ca2'
          when '0.9.4' then 'd79f58164012fc4971e66170718424be14e880b0c8ed1d24c51fe28228c7091c'
          end
        when 'freebsd-amd64'
          case resource.version
          when '0.7.0' then 'c0ee3541cc53b6d1502e2629f24cec64ce5b07b4f867c648755fbdb26075a3b2'
          when '0.7.1' then '930a8c7c26270e2b535f8342c6e54b879b34b66049d4c1999055e278a6dea098'
          when '0.7.2' then '3613f8005919265db6afa21f61d1a0847a2efbdc7dd0dd6db08b981313be67ac'
          when '0.7.3' then '050a7f497ac70ad55a511eef2086b647edc13b0dec103f2fcf37fe0c24b3e11e'
          when '0.8.0' then 'adee18e186d8ba4ca3fd6fe60801ad2016f4b645944bbe3a2401b54acc3035a5'
          when '0.8.1' then 'f0bc6b4bf2cb360ecb315084429ee68e3685a57756bcb291cede8058b321cdf2'
          when '0.8.2' then 'f08dcd9e5f9bc78c258e31ab4e12e819a5d8020132fbce76c5f9a891d2bf26a3'
          when '0.8.3' then 'c00ef72f67480f79c303f073719b10bf2dc55a5cf72bc8787e592ae5b38496b6'
          when '0.9.0' then '9c4b5af5b88f1910992cd06ba52e02be462628d361a3e157fe8e07a7a296fe2a'
          when '0.9.1' then '9deafa14a7dbb9170da1364a793c7d030d7e05c2cd34e59083ba9f63dcd82081'
          when '0.9.2' then 'a4208bd24aeb41c78edb910e9472939c9caadb869b1a6a5c773569f34a9c64ed'
          when '0.9.3' then 'dcd900f790182d8092dbf9b59f89c8570cef00a7ac86f83b85125e49b8aa4333'
          when '0.9.4' then '65fdbc0799f5dafe7f7ace2104be5149c9b99d877223d54f289855a85dbe65c4'
          end
        when 'freebsd-arm'
          case resource.version
          when '0.7.0' then 'e74972a2136487e70cb224303ee8a9daebc71162b1b2f1b1dca36489a6105fc0'
          when '0.7.1' then 'bc5bd7f522f8bc075a5811e491e981066bdb15a40c0a562dd1200a88a0e79f20'
          when '0.7.2' then '68c67cc3fcfa77da1883eb200cf1829cbaa86f6143df698dd38e99fb4e828839'
          when '0.7.3' then 'bac8780174cdcb896e8507ca0f41acd38479cbcb6bebf0a893bbbd4cfcbb6a2f'
          when '0.8.0' then '25ec2c26f037dc9a8b9db97eede0f1ee16f55906da16be974e3aa12af1093d8b'
          when '0.8.1' then '0850e91f37d7df84b60491d238da3662807b378b20cb7f895713880443948e25'
          when '0.8.2' then '0e8ccc94e61856aaf9dc548a6a2b51f1e65fa05791578c641ad8b50e33bf5e4e'
          when '0.8.3' then '67279a3ee4b23bbdc93a1fcf7302ce2405448df291f581a6fdbc45530094036b'
          when '0.9.0' then '9fdb89dbfc97ff46a671037945fbb755a4ca89f818d84a2727c968d2d3c78f46'
          when '0.9.1' then '10e40e59ccd4f326d1d85f72f3bf7b543f018ef2ad92d4fefab413f63911df11'
          when '0.9.2' then 'f43307389a9d2f59613283a57782c7aac493ac776fd7b73134b755b5a8a9453f'
          when '0.9.3' then '7a1c3d5d55c0bc0cf9d0525bc0a5c1dc5983d466d2f139c95a8a97329b77a7ec'
          when '0.9.4' then '23cc26aebd71d6b6201a44a42b799be7ffe1a61c13dd229d098c51163ddb6dd3'
          end
        when 'linux-i386'
          case resource.version
          when '0.7.0' then 'b4bcf45ca5fa006a4d7f8e226e0483201c71ee2b7fb01c73db116a4fe6c29c9f'
          when '0.7.1' then '761783a5a66dddbc74fd87606760379ad992cc4649611ec4ec4fb51c865676eb'
          when '0.7.2' then 'f43b4d705bf96bc4ebfdeea18e6b9966851d8774c9f7bef0f06c96ffb406815a'
          when '0.7.3' then 'd66f17811f95ed5ef8f1a4062c7b2781f751ce3e4778c3d00373813159d94afc'
          when '0.8.0' then '49e7080aed4ebbcf21a9aeb0a3a3c595a2e5435127c9794839f0a9113b28d4c0'
          when '0.8.1' then 'a2f8ee8e3301487639c62b79c2c9911976c42f2cf55cb6ea4edd9ebb27a7f47b'
          when '0.8.2' then '8511607aac0be1f5de96b71dbd1fc99bd05c37da048a0633db73840d6f353722'
          when '0.8.3' then '01d29a91498437027728f382c6e6551e64b380f506e276577c673e998f5aed70'
          when '0.9.0' then 'cb031729aaed37558142c7cf4861d02fd4e36d77b9e3407a1b9bec708be0ac79'
          when '0.9.1' then '03ecc356f6cac1b3633428490df9b0db412078e7b43e9fdd2b6484eb527b3799'
          when '0.9.2' then 'e094a3eb1a80003e80c332797cb4b4a3ca31dc4e897d8c6832e2fcaabf0d6815'
          when '0.9.3' then 'd37834916716c9d71fba9c703fd2b69f3de037175a789c85c412ecb0810d10ac'
          when '0.9.4' then 'd04dbb596d16f4f5bb49e6f4cf5e8b4fe08f57b3661bddfc7cf9b480c65b8237'
          end
        when 'linux-amd64'
          case resource.version
          when '0.7.0' then 'c6d97220e75335f75bd6f603bb23f1f16fe8e2a9d850ba59599b1a0e4d067aaa'
          when '0.7.1' then 'a576fe2c717ea4b5968477757196ff5308dbded4f5083c91d9e2ea824d2d6fdc'
          when '0.7.2' then '22575dbb8b375ece395b58650b846761dffbf5a9dc5003669cafbb8731617c39'
          when '0.7.3' then '2822164d5dd347debae8b3370f73f9564a037fc18e9adcabca5907201e5aab45'
          when '0.8.0' then '4a0a6fd53ac6913ae78c719113a18cca0569102ce25cfbf1d9e81bdb3c5c508f'
          when '0.8.1' then '3c4d70ba71619a43229e65c67830e30e050eab7a81ac6b28325ff707e5914188'
          when '0.8.2' then 'b7050bbc0b9ad554dd03040d1e5ad9c3b0cafde7e781f65433e4db5d05882245'
          when '0.8.3' then 'a3b687904cd1151e7c7b1a3d016c93177b33f4f9ce5254e1d4f060fca2ac2626'
          when '0.9.0' then '801ce0ceaab4d2e59dbb35ea5191cfe8e6f36bb91500e86bec2d154172de59a4'
          when '0.9.1' then '6308013ee0d6278e98cdfe8d6de0162102a8d25f3bcd1e3737bf7b022a9f6702'
          when '0.9.2' then 'abd9f26b71a693e43b0c55ec80c485f1a87f156e53fbf7e9bbccb1eba217761a'
          when '0.9.3' then '4ba8b9dafb903d20b4c87e8954015a07a6995f53a9650ac02b39e6cae502645e'
          when '0.9.4' then 'b312dfe783f69f5284d350714468f005dbb023f26ac9525d267550fb3dd2eea5'
          end
        when 'linux-arm'
          case resource.version
          when '0.7.0' then '0809126db9951c5b31aadf4c538889dc720d398d7f05278f50d794137edb95a9'
          when '0.7.1' then '4ca79a827ddf1ac11dc1ef4d4ba0f3cd72b24e33f194df3c0bc6fe73ff07bac9'
          when '0.7.2' then 'bbe3dc39471f95664be90e8210d15dd950a80ff0977fd51209ef5bafe7cf3862'
          when '0.7.3' then 'd45655f5ccdab762ad37f1efcdfc859f15a09e6ff839a2ba2f2484c173e8903b'
          when '0.8.0' then '0101bd92bde72385439dcdf7a90bc0eb4ce31218bb67206faae568c5fe6b237f'
          when '0.8.1' then 'ae05218e62030436894443456d4af21059181cada1c0b570f42b971bec404e78'
          when '0.8.2' then '2d73c5f26df2cfdfc5b36872d7e651591ebf5e1918735e83b3594886aa46b2c4'
          when '0.8.3' then 'be59ad54cc2c2f4534c859c3abed2e9749855ba0b30a1f95690616d80d3a81cb'
          when '0.9.0' then '2d2928eeccec4a83d78fb79294ba2fb3b3dd3dff4bd9c645514c5964c77dcdd4'
          when '0.9.1' then '764c296ba9b3a0c9107b3bb3269bb7787860e94159861e9022f733a335e7bd49'
          when '0.9.2' then '7030fa8fa4af309af95610efd83f513a1a96562e97de9c56a6af52203259d6b1'
          when '0.9.3' then '1e5b658fb6416560cf6b283d39e9a9ac06d618484f8345ca8f049a93a1e7283c'
          when '0.9.4' then '364bae8f022f50c48b6d2028d48e433d2d971d1aad41249a2d2e48d43c3b8000'
          end
        when 'windows-i386'
          case resource.version
          when '0.7.0' then '50541390d4de9e8906ad60eab2f527ec18660a5e91c3845f7d15e83416706730'
          when '0.7.1' then 'efdd4c064af9fe7ec5508ef07075a3c68192cd6a9ed3c68b201bbf9d5cd02112'
          when '0.7.2' then '0ed812c3a16720058c6e92a9a552ccc5d73c6d8d6fbd89e372a19e57a7b0a185'
          when '0.7.3' then '6a39b91e72fa8743b76b998ecdf9432acf6f75b98e9975c3f5cad49d5597146d'
          when '0.8.0' then '5dfb575f7d93b9a44a6ba0be9f0bb35604c7f7636303e2ebc27007b97aa44713'
          when '0.8.1' then '0a5e1ae2160e7237ebabc970b41e91fc42f5901000dcd185e8e7c74f532cc459'
          when '0.8.2' then 'a29e86465cca8293f803aed62f25a34295e0ed79122ca855cedc5d3fb6611b12'
          when '0.8.3' then '1fb1d837a085e1feceae00753b496735db746674ad3c55938f50545d1607dc32'
          when '0.9.0' then 'fd5bd46eb10951cf3d35cbff4d00e6c4e1110311d6e86968d997d4bf294db8b9'
          when '0.9.1' then 'fecac943606c9549d026ce6aa6b98baf659b5f78f284e8ddcef81bb21199b24b'
          when '0.9.2' then '405d746a2d0b7f359d8579a82b1eedc94f69b210f4f10de2ccc3d62f58da3064'
          when '0.9.3' then '2241cc1cc711d056c8774e081965dec7a0c3524f32a622802e68c32726349915'
          when '0.9.4' then '0f175e7c90de03cb022a82116c9bb60d542cac4d8bfb0e30c9b0eeccc2343083'
          end
        when 'windows-amd64'
          case resource.version
          when '0.7.0' then 'c4d4556665709e0e5b11000413f046e23b365eb97eed9ee04f1a5c2598649356'
          when '0.7.1' then '27f6f476650d61b1435bd8f24eca97ecabcb789e1e8a0f8388d59ac4f90517ad'
          when '0.7.2' then '718139c6f4bd918d5f94cd380b7b8db4664915d8d64acba0792a31ba102025a8'
          when '0.7.3' then '44b9f7b9c87b2c5df71a2462518299bfb165b9c3fd839d2ff817acce9af3a9e4'
          when '0.8.0' then 'dc9e9fda4cc89050b7a6ff9068acd548db52501be8028bd2f832ad3ef754ef9c'
          when '0.8.1' then '19f04a5989027245c88ced39032157240a49f186646a4497a15e3cc2a4839ebb'
          when '0.8.2' then '5395c306bfb033a426f3752a1070ec641372b32134e34f6cd43c53a3f2ed4946'
          when '0.8.3' then '9cdef19513bc0e8d51a2764505bbcda3b5caa3db83f4fbe2c64cd2d0d6e5779c'
          when '0.9.0' then '118fa03cbdc9629da151d42f8b023751ac7cdf94b072f584f1513f1748bdf8e8'
          when '0.9.1' then '5181a518ab1a8516ec1b155128282763a7794baa92b4c8cf502e5effc933383e'
          when '0.9.2' then '9e64cd2a337fc25f9c29dbf5d1b1620527a53939f3d434fe5cea753552a72635'
          when '0.9.3' then '3a394704640239b4b8980c88822b2513fd7e9fa385f2eb7beb2bea990b9c0f04'
          when '0.9.4' then '4d0b517907f708eae43b85f96ea5a6c92842a7350aaa20a88600d9e2589a1afb'
          end
        end
      end
    end
  end
end
