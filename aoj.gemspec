# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aoj/version'

Gem::Specification.new do |spec|
  spec.name          = "aoj"
  spec.version       = AOJ::VERSION
  spec.authors       = ["na-o-sss"]
  spec.email         = ["naoyoshi0511@gmail.com"]
  spec.summary       = %q{aoj submitter}
  spec.description   = %q{Submitter program which submits your source to AOJ(Aizu Online Judge) and retrieves result of judgement.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "thor"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "oauth"
end
