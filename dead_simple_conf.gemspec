# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dead_simple_conf/version"

Gem::Specification.new do |s|
  s.name        = "dead_simple_conf"
  s.version     = DeadSimpleConf::VERSION
  s.authors     = ["Julien Ammous"]
  s.email       = []
  s.homepage    = ""
  s.summary     = %q{Config loader}
  s.description = %q{YAML Config loader}

  s.rubyforge_project = "dead_simple_conf"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- specs/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency 'schmurfy-bacon', '> 1.2'
  s.add_development_dependency 'guard-bacon',    '> 1.0.2'
  s.add_development_dependency "growl", '~> 1.0.3'
  s.add_development_dependency "rb-fsevent", '> 0.4.3'
  s.add_development_dependency "mocha", '~> 0.10.0'
  s.add_development_dependency "simplecov", '~> 0.5.3'
  s.add_development_dependency "rake", '~> 0.9.2'
    
end
