# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_desk/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_desk"
  spec.version       = SimpleDesk::VERSION
  spec.authors       = ["John Gesimondo", "Elijah Murray"]
  spec.email         = ["john@jmondo.com", "elijah@bluefantail.com"]
  spec.summary       = %q{Provides a clean and simple gem to connect to Simpledesk}
  spec.description   = ""
  spec.homepage      = "http://github.com/sendsonar/simple_desk_gem"
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

  spec.post_install_message = <<-MESSAGE
  !    The 'simple_desk' gem has been deprecated and has been replaced by 'send_sonar'.
  !    See: https://rubygems.org/gems/send_sonar
  !    And: https://github.com/sendsonar/send_sonar_gem
  MESSAGE
end
