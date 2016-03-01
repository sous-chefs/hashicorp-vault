source 'https://rubygems.org'
gem 'chef-vault', '~> 2.6'
gem 'poise', '~> 2.5'
gem 'poise-service', '~> 1.1'
gem 'poise-boiler'

group :lint do
  gem 'rubocop'
  gem 'foodcritic'
end

group :test, :integration, :unit do
  gem 'berkshelf'
  gem 'chef-dk'
  gem 'chefspec'
  gem 'inspec'
  gem 'kitchen-inspec'
end

group :development do
  gem 'awesome_print'
  gem 'rake'
  gem 'stove'
end

group :doc do
  gem 'yard'
end
