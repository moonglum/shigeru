# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shigeru/version'

Gem::Specification.new do |spec|
  spec.name          = "shigeru"
  spec.version       = Shigeru::VERSION
  spec.authors       = ["Lucas Dohmen"]
  spec.email         = ["lucas@dohmen.io"]

  spec.summary       = %q{A routing library agnostic uri_for helper}
  spec.description   = %q{Define routes for your apps independent of your routing. Then generate your URIs with a uri_for helper.}
  spec.homepage      = "https://github.com/moonglum/shigeru"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "cutest", "~> 1.2.3"
  spec.add_development_dependency "rake", "~> 10.0"
end
