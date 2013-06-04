# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redex/version'

Gem::Specification.new do |gem|
  gem.name          = "redex"
  gem.version       = Redex::VERSION
  gem.authors       = ["Ezekiel Smithburg"]
  gem.email         = ["tehgeekmeister@gmail.com"]
  gem.description   = %q{A simplified PLT Redex clone in ruby}
  gem.summary       = %q{Redex is an extremely simplified clone of PLT Redex in Ruby.}
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
end
