# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_desk/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_desk"
  spec.version       = SimpleDesk::VERSION
  spec.authors       = ["Elijah Murray"]
  spec.email         = ["elijah@bluefantail.com"]
  spec.summary       = %q{Provides a clean and simple gem to connect to Simple Desk}
  spec.description   = %q{}
  spec.homepage      = "http://elijahish.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
