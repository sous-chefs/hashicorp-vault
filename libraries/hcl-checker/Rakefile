require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |c|
  options = ['--color']
  options += ['--format', 'documentation']
  c.rspec_opts = options
end

desc 'Generate Grammar files for HCL'
task :build_grammar do
  print 'Building Lexer'
  `rex ./assets/lexer.rex -o ./lib/hcl/checker/lexer.rb`
  print "....done\n"
  print 'Building Parser'
  `racc ./assets/parse.y -o ./lib/hcl/checker/parser.rb`
  print "....done\n\n"
end
