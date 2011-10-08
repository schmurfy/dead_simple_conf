
require 'bundler/setup'

if ENV['COVERAGE'] && (RUBY_VERSION >= "1.9")
  require 'simplecov'
  SimpleCov.start do  
    root File.expand_path('../..', __FILE__)
  end
end

require 'mocha'
require 'bacon'

require 'dead_simple_conf'
Bacon.summary_at_exit()
