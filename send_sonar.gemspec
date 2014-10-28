# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'send_sonar/version'

Gem::Specification.new do |spec|
  spec.name          = "send_sonar"
  spec.version       = SendSonar::VERSION
  spec.authors       = ["John Gesimondo"]
  spec.email         = ["john@jmondo.com"]
  spec.summary       = %q{Provides a clean and simple gem to connect to Sonar}
  spec.description   = ""
  spec.homepage      = "http://github.com/sendsonar/send_sonar_gem"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 2.6"
  spec.add_development_dependency "webmock", "~> 1.1"

  spec.add_runtime_dependency "rest-client", '~> 1.6'
end
