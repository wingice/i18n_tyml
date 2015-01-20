# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'i18n_tyml/version'

Gem::Specification.new do |spec|
  spec.name          = "i18n_tyml"
  spec.version       = I18nTyml::VERSION
  spec.authors       = ["William"]
  spec.email         = ["wingicelee@hotmail.com"]
  spec.summary       = %q{Parse I18n.t function call, and output with yaml format.}
  spec.description   = %q{Parse I18n.t function call, and output with yaml format..}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) } 
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
