# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'send_sonar/version'

Gem::Specification.new do |spec|
  spec.name          = "send_sonar"
  spec.version       = SendSonar::VERSION
  spec.authors       = ["Matthew Berman"]
  spec.email         = ["matt@sendsonar.com"]
  spec.summary       = %q{Provides a clean and simple gem to connect to Sonar}
  spec.description   = ""
  spec.homepage      = "http://github.com/sendsonar/send_sonar_gem"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15", ">= 1.15.4"
  spec.add_development_dependency "rake", "~> 12.1"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "vcr", "~> 3.0", ">= 3.0.3"
  spec.add_development_dependency "webmock", "~> 3.0", ">= 3.0.1"
  spec.add_development_dependency "json", "~> 2.1"

  spec.add_runtime_dependency "rest-client", "~> 2.0", ">= 2.0.2"
end
