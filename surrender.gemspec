# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'surrender/version'

Gem::Specification.new do |gem|
  gem.name          = "surrender"
  gem.version       = Surrender::VERSION
  gem.authors       = ["François Beausoleil"]
  gem.email         = ["francois@teksol.info"]
  gem.description   = %q{Given a list of files on STDIN, returns on STDOUT the list of files that should be rm'd - namely the list of files which don't match the retain rules.}
  gem.summary       = %q{Acts as a filter, returning the list of files that don't match the retain rules}
  gem.homepage      = "https://github.com/francois/surrender"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec", "~> 2.14"
  gem.add_development_dependency "rake"
end
