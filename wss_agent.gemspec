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
  spec.description   = %q{White Source agent to sync gems}
  spec.homepage      = "https://github.com/whitesource/ruby-plugin"
  spec.license       = "Apache License 2.0"

  spec.files         = [
    'lib/wss_agent.rb',
    'lib/wss_agent/version.rb',
    'lib/wss_agent/cli.rb',
    'lib/wss_agent/specifications.rb',
    'lib/wss_agent/configure.rb',
    'lib/wss_agent/response.rb',
    'lib/wss_agent/client.rb',
    'lib/wss_agent/gem_sha1.rb',
    'lib/wss_agent/project.rb',
    'lib/config/default.yml'
  ]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.executables   = %w(wss_agent)
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", '~> 0.10', '>= 0.10.1'
  spec.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.0'
  spec.add_development_dependency 'webmock', '~> 1.20', '>= 1.20.4'
  spec.add_development_dependency 'timecop', '~> 0.7', '>= 0.7.1'
  spec.add_dependency 'thor', '~> 0.19', '>= 0.19.1'
  spec.add_dependency 'yell', '~> 2.0', '>= 2.0.5'
  spec.add_dependency 'excon', '~> 0.42.1'
  spec.add_dependency 'faraday', '~> 0.9', '>= 0.9.1'
  spec.add_dependency 'faraday_middleware', '~> 0.9', '>= 0.9.1'
  spec.add_dependency 'awesome_print', '~> 1.6', '>= 1.6.0'
  spec.add_dependency 'oj', '~> 2.11', '>= 2.11.2'
end
