# -*- encoding: utf-8 -*-
require File.expand_path('../lib/zitdunyet/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "zitdunyet"
  gem.version       = Zitdunyet::VERSION
  gem.authors       = ["David Pellegrini"]
  gem.email         = ["david.pellegrini@spoke.com"]
  gem.description   = %q{Evaluate how done or complete a process or entity is.}
  gem.summary       = %q{DSL to describe the steps to completion and evaluation engine to compute done-ness.}
  gem.homepage      = ""

  gem.rubyforge_project = "zitdunyet"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
