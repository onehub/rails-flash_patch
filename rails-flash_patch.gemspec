# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "flash_patch/version"

Gem::Specification.new do |s|
  s.name        = "rails-flash_patch"
  s.version     = FlashPatch::VERSION
  s.authors     = ["Jason Nochlin"]
  s.email       = ["hundredwatt@gmail.com"]
  s.homepage    = "https://github.com/hundredwatt/rails-flash_patch"
  s.summary     = %q{Session inter-operability for Rails 3.0 and 3.1+ apps}
  s.description     = %q{Session inter-operability for Rails 3.0 and 3.1+ apps}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'actionpack',         '~> 3.0'

  s.add_development_dependency 'rake',     '~> 10'
  s.add_development_dependency 'bundler',  '~> 1.2'
end
