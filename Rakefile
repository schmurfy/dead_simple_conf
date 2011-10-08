require "bundler/gem_tasks"

task :test do
  require 'bacon'
  ENV['COVERAGE'] = "1"
  
  # Bacon.summary_on_exit
  
  Dir[File.expand_path('../specs/**/*_spec.rb', __FILE__)].each do |file|
    load(file)
  end

end
