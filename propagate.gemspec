# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "propagate/version"

Gem::Specification.new do |s|
  s.name        = "propagate"
  s.version     = Propagate::VERSION
  s.authors     = ["Propagate"]
  s.email       = ["propagate@arcane.com.br"]
  s.homepage    = "http://www.propagate.com.br/"
  s.summary     = %q{Helpers for the Propagate API}
  s.description = %q{This plugin adds helpers for the Propagate API}

  s.rubyforge_project = "propagate"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency "mocha"
  s.add_development_dependency "rake"
  s.add_development_dependency "activesupport"
  s.add_development_dependency "i18n"
end
