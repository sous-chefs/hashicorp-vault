#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
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
        archive_url = format(options[:archive_url],
          version: options[:version],
          basename: options[:archive_basename])

        notifying_block do
          directory ::File.join(options[:extract_to], new_resource.version) do
            recursive true
          end

          zipfile options[:archive_basename] do
            path ::File.join(options[:extract_to], new_resource.version)
            source archive_url
            checksum options[:archive_checksum]
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
          when '0.1.2' then 'a4264b83432d8415fa8acbe60dafee7de119fba8b2472211861bd40a5e45381f'
          when '0.2.0' then '22f003b89dc34e6601f8d6cbcd79915bd010e0fa1a14fc291adc4905c5abcc00'
          when '0.3.0' then 'c0410040c6b26bdcdb619ab5b32c195b92c968dccb7d9c9aa96127a5614ad0f6'
          when '0.3.1' then '4ff4ef6e0c0507a09be569c72e49fe4b013acc1a3fa8eedae2e267f7f39cdf08'
          when '0.4.0' then 'dad7401d0692e531713d8c0b23e77dea1f7df9cb1c689e3e2dea06b607100f30'
          when '0.4.1' then '9dd6e5c2d233d048d05ebdbae4dbf5e2b10d0e6d1bd626a609e913b1c8f923e0'
          when '0.5.0' then 'a0c783b6e4c5aa8c34c0570f836b02ae7d9781fc42d5996a8c3621fec7e47508'
          when '0.5.1' then 'b28a68ce1c6403092485ed17622fd127180559e26cefb1ff7c6bd539319294fd'
          when '0.5.2' then '0a7bf80f41cff7928acf99450b5de0f18472b83e985087b1a45fd6d078707dc8'
          when '0.5.3' then '6f7384b2a65ec44b5a3ce4da04f8c6e29756462f12eff2f126b2e43790d0e3c9'
          when '0.6.0' then 'ac86de0e90a82ef826c5670be159122a629f74596e4901a3e059cab4650dff4c'
          when '0.6.1' then '3e17fe720ce6d9d19b0f19000865a5e033a7d3dca106b867e348d9ae6f3b827a'
          when '0.6.2' then '03947fd6cf3f67c3f40da2486661851b7ffa3b9a8c5957904c32c918aae4c9fb'
          when '0.6.3' then '61cffd444bae4e9b8c5c5aa6bba3d4dc9bf6879730295302436be6a996d238f8'
          when '0.6.4' then 'e0ba582c0a7b5d42b44903e0f87267a0262d6d1fe6dc41161c15ef87b48b071f'
          when '0.6.5' then '553d65782a853777e5c954bea262bb6f81ac956e5cedb9e03fd88d07a685d90f'
          when '0.7.0' then '11d60c33e45ec842876ff7828eb1adf2abe97d1e845f92d7234013171d3a977e'
          when '0.7.1' then '1209a163aba27f3c1d7baaf08f0b04c1e11527d8d4b0d5b11b0f33503a19f2ca'
          when '0.7.2' then '1832fba41de86b551674addc87b591708456f68f3b4fe4daf007e08864e4a7ee'
          when '0.7.3' then '5ab070055bbcad9c59ab32d6f4479b432fcab0934fd4f251e1851bfb01b6487a'
          when '0.8.0' then '146d287faa8a397788189289acc54957f6899dadc83000d423651556f555b0c7'
          when '0.8.1' then 'ef835bb803ce45baab97fbe475e62f1124511190631923d4352d04c9e1cecce4'
          when '0.8.2' then '22e074ae2b7e43c5784b06c1a1c3b0d6a036972d362a5d7ace1cd82e4ad29687'
          when '0.8.3' then '774747c847be21a599e2e5ff44794397629cc9de19bbd324ffb3402c7574adba'
          end
        when 'darwin-amd64'
          case resource.version
          when '0.1.2' then '42fe870cedb1152d1cb43e22c14a8786a30476764055de37a2fbf98e92cebe9b'
          when '0.2.0' then '73dfa187a01fd4490b4c8a62a4316a4bd054538d4fd2df869415b0b00f37d654'
          when '0.3.0' then 'f6c7a30671a90df09d39197262e019a7dd7ad36a68d2f5895080b899aa81fc58'
          when '0.3.1' then '0a67d3ee6743c96e6cb96484b208555a2ea6f19fd7b51057410fd6f4a49aafad'
          when '0.4.0' then 'be81a99496c9949d261cf119cd58ee617088fffd9feaa045605e00063c490bb6'
          when '0.4.1' then 'cdf4f8bb863550e6b29aa44254ed00968f69c9e6b7e9e8c83d70151fe905bd99'
          when '0.5.0' then '8f5ca5927f876737566a23442f098afa1ed3dc9d5b238c3c8f7563e06ab6c64c'
          when '0.5.1' then '0466e5a0bfe777586ce4c9b3dfa9f48bbc6e902550aefbb2281725a3bd46179c'
          when '0.5.2' then '48bf1d66cc3b81293186fd458f63fc2b02344aec5f1490c9b9a2915831c13d33'
          when '0.5.3' then '31e7eff07c202cf2166ac63457054da59a1f4f49e7ad079b38316efadbb79e32'
          when '0.6.0' then '75a884f3f209f2fdd942fc4b5c80a611c58380ccf249f6dc4d3b1c35373d87b2'
          when '0.6.1' then 'a2daa1f8669899296c193347664f97e4acec97d298ebac489b60a03dae8aca4d'
          when '0.6.2' then 'b5e6fadfed6a5226d96714f5ddcf7e042f3424d7489875af125543c967a706b7'
          when '0.6.3' then 'dc1d97e403177f8cfeee20cac83a2b323cafa80f67bbb048df879ab2a4fdd616'
          when '0.6.4' then '83f680b5e2aaa4c1c2a1a5dbc7479e63186233b6cdda64e24b968f6f1856b676'
          when '0.6.5' then 'abad5d79c3b81e07405c00997ec5d646e171eaab644a3c35354a03eb2d43c8e9'
          when '0.7.0' then 'db995adf0e46dd7ae43d2fa3523f44a007a6adc37c3a47de5c667a1361cffc13'
          when '0.7.1' then '9060e4e64b76b566b8ea4f5c76df605292c2aa184b6ec6c1e1fa1afe343e371d'
          when '0.7.2' then '1b29fabd094ab1afbb26ec6c3df3f7c3deef5ef408bb24db94ae07a330ab5317'
          when '0.7.3' then 'fa9badde19ba0bb9d7341ac0521593c09ea15a00ed824382c1f58855d2e0959c'
          when '0.8.0' then 'ae57608c662942bbcf00a05daad60df3f7f2d9f2d672b4e3490498c518704f20'
          when '0.8.1' then '8efa6ef642edf9fc48a6a7e2b0a24aec9b143369bca90add7724ddcf1e358ffd'
          when '0.8.2' then '55dd805fa96a0142b941b1e79c16cf02bd3555546ac51c26f8f307e91eeb966d'
          when '0.8.3' then '43c211d0a2ced793a25ac157cc4f3e2160ea9aa57f8d91f805a51e78a5b0b538'
          end
        when 'freebsd-i386'
          case resource.version
          when '0.5.2' then 'b14aa86a1573125fb0521800e53d04bbfa1f2d5c4fee5cfe62ab42c45ff941ef'
          when '0.5.3' then '2b534ac83808e1b69a683083c0c8037c992c364ec2df593f829688de4c43d457'
          when '0.6.0' then 'bac35e72777929db08218c04f0723a30e2e5c0bfbb50cebd4fb9bc5314ddcc0a'
          when '0.6.1' then '843f72d7fa75c951e24c2da33f4ec7e49096f494d4622970bf46702046ac3704'
          when '0.6.2' then '462a40d7a99f20fa831a0663a5172ea84576bdab8d78bc5f8102099fd31561c5'
          when '0.6.3' then '82634a91e494df37ef1509381a859ff1b8c3bd5e3564b3917a53964f7bed27e2'
          when '0.6.4' then 'd1815b0f8cbda1a8b683675e2acaf45a62f2e2f0421b935f78862f5a376e9494'
          when '0.6.5' then '8b9f91a96705772f10fff6ea1106d8714c06e12b4eda3256ff0dcd435a9accb6'
          when '0.7.0' then 'd215da31431b91e5563152566f818a40df6ee2d07e2a43f5e2561edd95631caf'
          when '0.7.1' then 'ee6ee44973bb1262c17e77bf364d354fc3b2bf0c858acd49e1cd1ae57d7ff98f'
          when '0.7.2' then '3a3f9f0187b341718137d5f158387e69778b5862a6f874682ceded25208dd2a1'
          when '0.7.3' then '9de7796867266623bb4d9151be4d54ded62c0f63c93a32c490d5787589acdbfb'
          when '0.8.0' then '13b46c16b17b781375739162b662a87050e53e70081247b4c2a64da3c5b01788'
          when '0.8.1' then 'f05680e765f23d7887aa6c33ea552b52c6f0507377271c2adc45b59f7b6981a2'
          when '0.8.2' then '9563ad994614113467387734498ea116b8b20791f24c65f52c1cebc14dd97894'
          when '0.8.3' then 'fea69b39c78493ff03d8744473dc64ec4a95553d34383b138a82058e22c337c6'
          end
        when 'freebsd-amd64'
          case resource.version
          when '0.5.2' then '63182658c91dacc7edb180b3e68365c928c74a6384d8837b57271d64deecd2b4'
          when '0.5.3' then 'fd791ba3053a3a6bd622da23590c88c37f97cb86926f2bcab1108a1933aeb862'
          when '0.6.0' then '3679e98164b7e995bb43a2af4459dcb4f9495de5460b6ce3cc8d0aa4bcf8c9a6'
          when '0.6.1' then 'f4eeee77ae24e51ee9feb793d659150240dfc617810c9f0b32e5628b5ea983c4'
          when '0.6.2' then 'f98585cbd5696bf5aff89a09a7b577525f2148d318ec4969df1a906a47db7a2f'
          when '0.6.3' then 'a31ab7468a0ddcc95fd759e24aeec8137911f29ca6af53afabcf62a770d9f0c0'
          when '0.6.4' then '91037896621bc4f234d8545c4407de236680eb7f078c22777afb630ce49ba38b'
          when '0.6.5' then 'df9c8bba6afe118b0fef753f7e3d8a344dfa9a60a008c9bc8d8cc4da60b6b50a'
          when '0.7.0' then 'c0ee3541cc53b6d1502e2629f24cec64ce5b07b4f867c648755fbdb26075a3b2'
          when '0.7.1' then '930a8c7c26270e2b535f8342c6e54b879b34b66049d4c1999055e278a6dea098'
          when '0.7.2' then '3613f8005919265db6afa21f61d1a0847a2efbdc7dd0dd6db08b981313be67ac'
          when '0.7.3' then '050a7f497ac70ad55a511eef2086b647edc13b0dec103f2fcf37fe0c24b3e11e'
          when '0.8.0' then 'adee18e186d8ba4ca3fd6fe60801ad2016f4b645944bbe3a2401b54acc3035a5'
          when '0.8.1' then 'f0bc6b4bf2cb360ecb315084429ee68e3685a57756bcb291cede8058b321cdf2'
          when '0.8.2' then 'f08dcd9e5f9bc78c258e31ab4e12e819a5d8020132fbce76c5f9a891d2bf26a3'
          when '0.8.3' then 'c00ef72f67480f79c303f073719b10bf2dc55a5cf72bc8787e592ae5b38496b6'
          end
        when 'freebsd-arm'
          case resource.version
          when '0.5.2' then 'fcccb3ef43de09861cafc7971b8276558cfc420dca8308c136c74176169213ef'
          when '0.5.3' then 'a3a1304fe7815d3f8e67e2fa095466456f2e6655f45a0461cb668774b8fd8464'
          when '0.6.0' then '6312579e84b9730775274f9ad47559142bac351a406cd0b6db73e0303ebeca17'
          when '0.6.1' then '5dd1a5979b36c2b5fde6b538b465c8c9a1c70e0adef144a605faca4b0c0c5d7f'
          when '0.6.2' then 'eabc0e7239a048e20119ab3ec0e6ea2e9c4187c0cd84b294b3d13f0120d86f1a'
          when '0.6.3' then 'c19ef6222d195f125a35e11106ce86a9c92d35559849d0b83dd4821a0de31451'
          when '0.6.4' then '4d514acd31f73f26d3c0d5450e5e0fe6b1b1474bb57098167b264165d2b6fdfe'
          when '0.6.5' then '96358370470d13b5843d021a199305e786809f26392ee4f399429017238b0453'
          when '0.7.0' then 'e74972a2136487e70cb224303ee8a9daebc71162b1b2f1b1dca36489a6105fc0'
          when '0.7.1' then 'bc5bd7f522f8bc075a5811e491e981066bdb15a40c0a562dd1200a88a0e79f20'
          when '0.7.2' then '68c67cc3fcfa77da1883eb200cf1829cbaa86f6143df698dd38e99fb4e828839'
          when '0.7.3' then 'bac8780174cdcb896e8507ca0f41acd38479cbcb6bebf0a893bbbd4cfcbb6a2f'
          when '0.8.0' then '25ec2c26f037dc9a8b9db97eede0f1ee16f55906da16be974e3aa12af1093d8b'
          when '0.8.1' then '0850e91f37d7df84b60491d238da3662807b378b20cb7f895713880443948e25'
          when '0.8.2' then '0e8ccc94e61856aaf9dc548a6a2b51f1e65fa05791578c641ad8b50e33bf5e4e'
          when '0.8.3' then '67279a3ee4b23bbdc93a1fcf7302ce2405448df291f581a6fdbc45530094036b'
          end
        when 'linux-i386'
          case resource.version
          when '0.1.2' then '20cf0fb7df3fb451bfd80ef7d14a7884d17e1a04b15ebdd3030d046d07d71b5a'
          when '0.2.0' then '9a4cb5470182e163eaa9d2526beb60c6a215c931c15452065f8caa4aa5821816'
          when '0.3.0' then '3f25189efd210d0fcbcaf4796389d7cf04b86c670a68909adef41d75a52b117f'
          when '0.3.1' then '2e09df75efed43c1f29c1be020ad49d712a6eb5b2413961aea7d5ed47b982f36'
          when '0.4.0' then '595af129648b0ea1c0810e6c976d298a16b4f2d348e1cf31ebac7800ebf66c0b'
          when '0.4.1' then '822b3bca3a4897b34ce45b9081dc48f89cc83c61dbacf4ff47a6dac2d1f70b39'
          when '0.5.0' then 'af416f99627f5d9d9516a86a6ec75e7b4056c11548951051d178a46171ea6b00'
          when '0.5.1' then '6b3c34bfff2af7fdb15c98a8b7eb59e12316db733e66c4ebdc3c2f09b9f31280'
          when '0.5.2' then '8305303aa9f4a0654961d0930d40bc61b3a0ad52e12d630e1619815de196e9fc'
          when '0.5.3' then '3ab3cd3ef72bdeea15291fb91436aee745c037d719c4e177d0290c884f325daf'
          when '0.6.0' then 'c2b148d88a8255c82fca18a7571fc153976464ee52ba1336d825ca9f65f74fd0'
          when '0.6.1' then 'c32231a7670f14489d1795d497edaa44c793eab42a4b3b2a74c8f8c877871520'
          when '0.6.2' then '85ca9e2d09e49089c76f00686d7914c840a2cbec0d18bf6429dc396265f7a730'
          when '0.6.3' then '9a5e7eadde0ba31779b81ebf9d012dd6c27edec2a7b8124dba7335d53d367a45'
          when '0.6.4' then '5a3d5fcfb996a576c0c11136cc6e471fe72bb12b5167694919ea95cbca466bd1'
          when '0.6.5' then '85dd505f57964add2359798faca0302877b95386a852331bb0e7d43367a41949'
          when '0.7.0' then 'b4bcf45ca5fa006a4d7f8e226e0483201c71ee2b7fb01c73db116a4fe6c29c9f'
          when '0.7.1' then '761783a5a66dddbc74fd87606760379ad992cc4649611ec4ec4fb51c865676eb'
          when '0.7.2' then 'f43b4d705bf96bc4ebfdeea18e6b9966851d8774c9f7bef0f06c96ffb406815a'
          when '0.7.3' then 'd66f17811f95ed5ef8f1a4062c7b2781f751ce3e4778c3d00373813159d94afc'
          when '0.8.0' then '49e7080aed4ebbcf21a9aeb0a3a3c595a2e5435127c9794839f0a9113b28d4c0'
          when '0.8.1' then 'a2f8ee8e3301487639c62b79c2c9911976c42f2cf55cb6ea4edd9ebb27a7f47b'
          when '0.8.2' then '8511607aac0be1f5de96b71dbd1fc99bd05c37da048a0633db73840d6f353722'
          when '0.8.3' then '01d29a91498437027728f382c6e6551e64b380f506e276577c673e998f5aed70'
          end
        when 'linux-amd64'
          case resource.version
          when '0.1.2' then '12c28cf7d6b6052c24817072fb95d4cfa2a391b507c705e960faf11afb5ee6ad'
          when '0.2.0' then 'b4b64fcea765ebfc7cdbae9cdd2c32bff130ca51f15b9cf47194f112fd5515cf'
          when '0.3.0' then '30b8953e98059d1e8d97f6a164aa574a346a58caf9c5c74a911056f42fbef4d5'
          when '0.3.1' then '4005f0ae1bd88ad2676859430209129ed13bc3ade6b64fcf40cc3a6d4d9469e7'
          when '0.4.0' then 'f56933cb7a445db89f8832016a862ca39b3e63dedb05709251e59d6bb40c56e8'
          when '0.4.1' then 'f21f8598728faa4e1920704c37047bad6e9b360aec39ba8a1cc712c373ffb61a'
          when '0.5.0' then 'f81accce15313881b8d53b039daf090398b2204b1154f821a863438ca2e5d570'
          when '0.5.1' then '7319b6514cb5ca735d9886d7b7e1ed8730ee38b238bb1626564436b824206d12'
          when '0.5.2' then '7517b21d2c709e661914fbae1f6bf3622d9347b0fe9fc3334d78a01d1e1b4ec2'
          when '0.5.3' then 'fddb97507f8b539534620882f3a46984160778950e4884831c0f7c2a82b65f52'
          when '0.6.0' then '283b4f591da8a4bf92067bf9ff5b70249f20705cc963bea96ecaf032911f27c2'
          when '0.6.1' then '4f248214e4e71da68a166de60cc0c1485b194f4a2197da641187b745c8d5b8be'
          when '0.6.2' then '91432c812b1264306f8d1ecf7dd237c3d7a8b2b6aebf4f887e487c4e7f69338c'
          when '0.6.3' then '8d28c4425e78a00c0f437393b7a87ff00bc3ce1aa0f10ef6538d1ba3181f1d08'
          when '0.6.4' then '04d87dd553aed59f3fe316222217a8d8777f40115a115dac4d88fac1611c51a6'
          when '0.6.5' then 'c9d414a63e9c4716bc9270d46f0a458f0e9660fd576efb150aede98eec16e23e'
          when '0.7.0' then 'c6d97220e75335f75bd6f603bb23f1f16fe8e2a9d850ba59599b1a0e4d067aaa'
          when '0.7.1' then 'a576fe2c717ea4b5968477757196ff5308dbded4f5083c91d9e2ea824d2d6fdc'
          when '0.7.2' then '22575dbb8b375ece395b58650b846761dffbf5a9dc5003669cafbb8731617c39'
          when '0.7.3' then '2822164d5dd347debae8b3370f73f9564a037fc18e9adcabca5907201e5aab45'
          when '0.8.0' then '4a0a6fd53ac6913ae78c719113a18cca0569102ce25cfbf1d9e81bdb3c5c508f'
          when '0.8.1' then '3c4d70ba71619a43229e65c67830e30e050eab7a81ac6b28325ff707e5914188'
          when '0.8.2' then 'b7050bbc0b9ad554dd03040d1e5ad9c3b0cafde7e781f65433e4db5d05882245'
          when '0.8.3' then 'a3b687904cd1151e7c7b1a3d016c93177b33f4f9ce5254e1d4f060fca2ac2626'
          end
        when 'linux-arm'
          case resource.version
          when '0.1.2' then '2f820f67e2126710c36870864a84eddc21b606c2646b675e7c8c3482be8f6f20'
          when '0.2.0' then '883414010c26104889505aee69b461d1ca9378725dd2c7caafdcd1bba2d9c039'
          when '0.3.0' then 'c57623ee3ba311451c5b8cc7cc1893e06ed38d19279390de784bf833d63e0bdb'
          when '0.3.1' then '920e5ea35212d6e885be93ef66d6a6045357f6f5f0a3415255339674544d33be'
          when '0.4.0' then '9883ff7d8cb858ce7163f75f3b6157aaa06d4b1a612d7fa9956869e73cc13bd4'
          when '0.4.1' then '2786009465d10db4777791e90b8cbb42753513dcfae52ba74132c2364b8b267f'
          when '0.5.0' then '722bf424694a60b5608af1bc2b5563ee06cedc03697d2ebc45676e8caf4e9f75'
          when '0.5.1' then '2cc0b40de5d0869b39e0a3fd7de308e6365b823a825a9d743dda0d3783d61655'
          when '0.5.2' then '458da2f7e65e7d03efad56bd60e1e747d303f94bee48ecfe8fe45d4207896142'
          when '0.5.3' then 'ee2e967e2473fd3868e78383e94e16e53a7c865372b3fc3bb42e1848a75dfa89'
          when '0.6.0' then 'c2b148d88a8255c82fca18a7571fc153976464ee52ba1336d825ca9f65f74fd0'
          when '0.6.1' then 'a3016e9acefc8af930b0ca855e6a995b164c6756f3f036e406faa6af71331669'
          when '0.6.2' then 'efc36dcb2044cf4c80af9e71abd9fb4716db8944e7d102f913d17f922a527189'
          when '0.6.3' then 'c192ad445d0a834047562ddcbc54a353a9ec6ae7fb286416e8180b58af53dcd5'
          when '0.6.4' then '9a12a504088cc4e5b77200273383fec081a7d3df690c04fd13bd7983652c0211'
          when '0.6.5' then 'b97e4da703b93870a614c53431da905029dbb54675f404f6a878536a1852fecf'
          when '0.7.0' then '0809126db9951c5b31aadf4c538889dc720d398d7f05278f50d794137edb95a9'
          when '0.7.1' then '4ca79a827ddf1ac11dc1ef4d4ba0f3cd72b24e33f194df3c0bc6fe73ff07bac9'
          when '0.7.2' then 'bbe3dc39471f95664be90e8210d15dd950a80ff0977fd51209ef5bafe7cf3862'
          when '0.7.3' then 'd45655f5ccdab762ad37f1efcdfc859f15a09e6ff839a2ba2f2484c173e8903b'
          when '0.8.0' then '0101bd92bde72385439dcdf7a90bc0eb4ce31218bb67206faae568c5fe6b237f'
          when '0.8.1' then 'ae05218e62030436894443456d4af21059181cada1c0b570f42b971bec404e78'
          when '0.8.2' then '2d73c5f26df2cfdfc5b36872d7e651591ebf5e1918735e83b3594886aa46b2c4'
          when '0.8.3' then 'be59ad54cc2c2f4534c859c3abed2e9749855ba0b30a1f95690616d80d3a81cb'
          end
        when 'windows-i386'
          case resource.version
          when '0.1.2' then '3baa8eb1334c8af0cf696e0a5510da9f68ec3ee3b45afaa9a3037ca2ea562338'
          when '0.2.0' then '64aa7893678ae047c61021c97499feb20f924e51f65e9b7ea257cc17355182ec'
          when '0.3.0' then '6151401f56a09188e958d3af8d99d58e6ea2984117b13998d57c245faed936e3'
          when '0.3.1' then '021834c98bb42e3c902c642326a637184c6519e2d40208e0976d885867042da2'
          when '0.4.0' then 'd2d8e9440f87221b6b5b887e0929ccfd6ba827a37755f7b10a40188e580040af'
          when '0.4.1' then '5b7dba8582947723c9064b1ca2ac6c285b6f4b78b4b5cc1bc31256c2baebe991'
          when '0.5.0' then '19afa686c438f9af5620aa091682f71f7f8284ab246f5d4701cba408833f8b5f'
          when '0.5.1' then '89e59dbe26146d1e3b17b122185d51737a383bb27cf407a25e13896fb7802e90'
          when '0.5.2' then '714a7f20051147e5424f3e4d4e3cf45a98eecf829175c3acf83001a57f33b990'
          when '0.5.3' then 'a7ca96079796d022a071f65cde96745f6511d7b1a84f70f2bac06885e16c09fa'
          when '0.6.0' then '1ee96b3a37369082db62b191232af7a84a75019414aad4e5f1e06fa81c0aa271'
          when '0.6.1' then '8faf63bff47a6a8ba0287b2ff1b462baf0ec9319b450c2e6b5b5f8950a9e2e1c'
          when '0.6.2' then '0273c2fc6afec1c8e2b62c610b675088d47d26d3a5dda801f23836baf566fe17'
          when '0.6.3' then '487e98ff32930f86083286fcd91cad8cb31f6639974eeb8f6c443eb40e5fde1b'
          when '0.6.4' then '1a1d2c6eccc9ce2b9e71c83b222cecbaed71036068e5a7744708821eedefa024'
          when '0.6.5' then 'cfc5a9a7beecdf7e7b8424d706b5f39c1d757f329e6ec490fb627d58f147d51e'
          when '0.7.0' then '50541390d4de9e8906ad60eab2f527ec18660a5e91c3845f7d15e83416706730'
          when '0.7.1' then 'efdd4c064af9fe7ec5508ef07075a3c68192cd6a9ed3c68b201bbf9d5cd02112'
          when '0.7.2' then '0ed812c3a16720058c6e92a9a552ccc5d73c6d8d6fbd89e372a19e57a7b0a185'
          when '0.7.3' then '6a39b91e72fa8743b76b998ecdf9432acf6f75b98e9975c3f5cad49d5597146d'
          when '0.8.0' then '5dfb575f7d93b9a44a6ba0be9f0bb35604c7f7636303e2ebc27007b97aa44713'
          when '0.8.1' then '0a5e1ae2160e7237ebabc970b41e91fc42f5901000dcd185e8e7c74f532cc459'
          when '0.8.2' then 'a29e86465cca8293f803aed62f25a34295e0ed79122ca855cedc5d3fb6611b12'
          when '0.8.3' then '1fb1d837a085e1feceae00753b496735db746674ad3c55938f50545d1607dc32'
          end
        when 'windows-amd64'
          case resource.version
          when '0.1.2' then 'aff1455f69278662c76b4d9615fe10af98eb4d3c0ea60b8c334a2064f23deed1'
          when '0.2.0' then '1905354ad1652a8bd33c23f546b9df0e22b2c20a157c28545ff20b3cd74ea9e9'
          when '0.3.0' then '012f79bb190817075d15a714e92fdb6fa26c638c46c4e9587143f5f69a2f3e0e'
          when '0.3.1' then '972c86317c4389db5edd3fadfebd3cd4c9a94c5bc6045dd3fec47d9cb4fe0491'
          when '0.4.0' then '6e91a7d8817a2fc03859dfeda40f4175593b273d3b2564d3e59e9405c1d8b260'
          when '0.4.1' then 'e1f1c31fea51c4477c975d81d16ec399bfe744398c06f21dc209fb88ae019201'
          when '0.5.0' then '47b02247d8f7c4944ffcca006b2a25124065d4e9e416494b177a2c0d3165b4e6'
          when '0.5.1' then '1f16b5203ab6e99970b983850ee775c85fed9fa3e558847cdd8b66138ccb17ae'
          when '0.5.2' then '6e718ca8af49785d0614ab6b35d584152e77da80ed8de7100d0929b354133e77'
          when '0.5.3' then 'a7ca96079796d022a071f65cde96745f6511d7b1a84f70f2bac06885e16c09fa'
          when '0.6.0' then '9944f854f37a96490395ffd229221659b6839bbb218288b9bc436be4ceca694d'
          when '0.6.1' then '53df96e47f67096f408b5f003641671a01170c88c85058771ef46f880b61b5dc'
          when '0.6.2' then '66b71cdc72ebea0dc766af252963004fc4959f3a4bebdd2f5f9d67258967b877'
          when '0.6.3' then '56cdfbfee5526def65d29c142dd76eae1451addc11ff3d980a07ccacddb6e142'
          when '0.6.4' then '83db81056e7146513d7a2707ce1b6cf73ae8aa69f942f8cd92da49e1a7de86ca'
          when '0.6.5' then '4ef04179efba3233f1b1fb91c6702a5c7896b1e7d0d7398500a9c0729e81edf7'
          when '0.7.0' then 'c4d4556665709e0e5b11000413f046e23b365eb97eed9ee04f1a5c2598649356'
          when '0.7.1' then '27f6f476650d61b1435bd8f24eca97ecabcb789e1e8a0f8388d59ac4f90517ad'
          when '0.7.2' then '718139c6f4bd918d5f94cd380b7b8db4664915d8d64acba0792a31ba102025a8'
          when '0.7.3' then '44b9f7b9c87b2c5df71a2462518299bfb165b9c3fd839d2ff817acce9af3a9e4'
          when '0.8.0' then 'dc9e9fda4cc89050b7a6ff9068acd548db52501be8028bd2f832ad3ef754ef9c'
          when '0.8.1' then '19f04a5989027245c88ced39032157240a49f186646a4497a15e3cc2a4839ebb'
          when '0.8.2' then '5395c306bfb033a426f3752a1070ec641372b32134e34f6cd43c53a3f2ed4946'
          when '0.8.3' then '9cdef19513bc0e8d51a2764505bbcda3b5caa3db83f4fbe2c64cd2d0d6e5779c'
          end
        end
      end
    end
  end
end
