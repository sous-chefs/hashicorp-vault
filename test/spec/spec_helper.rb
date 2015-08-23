require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'
require 'chef-vault'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '14.04'

  config.color = true
  config.alias_example_group_to :describe_recipe, type: :recipe

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  Kernel.srand config.seed
  config.order = :random

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end

at_exit { ChefSpec::Coverage.report! }

RSpec.shared_context 'recipe tests', type: :recipe do
  before do
    stub_command('test -L /usr/local/bin/vault').and_return(true)
    stub_command('getcap /srv/vault/current/vault|grep cap_ipc_lock+ep').and_return(false)
  end
end
