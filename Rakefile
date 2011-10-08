require "bundler/gem_tasks"

task :default => :test

task :test do
  require 'bacon'
  
  # do not generate coverage report from travis
  unless ENV['TRAVIS']
    ENV['COVERAGE'] = "1"
  end
  
  # Bacon.summary_on_exit
  
  Dir[File.expand_path('../specs/**/*_spec.rb', __FILE__)].each do |file|
    load(file)
  end

end
