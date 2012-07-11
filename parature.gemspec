# -*- encoding: utf-8 -*-
require File.expand_path('../lib/parature/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jamie Ly"]
  gem.email         = ["me@jamiely.com"]
  gem.description   = %q{A gem to interact with Parature}
  gem.summary       = %q{A gem to interact with Parature}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "parature"
  gem.require_paths = ["lib"]
  gem.version       = Parature::VERSION

  gem.add_dependency 'rest-client'
  gem.add_dependency 'json'
  gem.add_dependency 'mechanize'
end

