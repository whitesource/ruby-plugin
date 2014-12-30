# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wss_agent/version'

Gem::Specification.new do |spec|
  spec.name          = "wss_agent"
  spec.version       = WssAgent::VERSION
  spec.authors       = ["Maxim Pechnikov"]
  spec.email         = ["parallel588@gmail.com"]
  spec.summary       = %q{White Source agent.}
  spec.description   = %q{White Source agent.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = [
    'lib/wss_agent.rb',
    'lib/wss_agent/version.rb',
    'lib/wss_agent/cli.rb',
    'lib/wss_agent/specifications.rb'
  ]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.executables   = %w(wss_agent)
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'thor', '~> 0.19', '>= 0.19.1'
  spec.add_runtime_dependency 'faraday', '~> 0.9', '>= 0.9.0'
  spec.add_runtime_dependency 'awesome_print', '~> 1.6', '>= 1.6.0'
  spec.add_runtime_dependency 'oj', '~> 2.11', '>= 2.11.1'
end
