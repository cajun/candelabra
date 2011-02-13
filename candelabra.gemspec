# -*- encoding: utf-8 -*-
require File.expand_path("../lib/candelabra/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "candelabra"
  s.version     = Candelabra::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = []
  s.email       = []
  s.homepage    = "http://rubygems.org/gems/candelabra"
  s.summary     = "Wrapper for pianobar"
  s.description = "initial wrapper for pianobar"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "candelabra"

  s.add_development_dependency "bundler"  , "~> 1.0.0"
  s.add_development_dependency "minitest" , ">= 2.0.2"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
