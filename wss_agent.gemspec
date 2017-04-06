# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wss_agent/version'

Gem::Specification.new do |spec|
  spec.name          = 'wss_agent'
  spec.version       = WssAgent::VERSION
  spec.authors       = ['Maxim Pechnikov']
  spec.email         = ['parallel588@gmail.com']
  spec.summary       = 'White Source agent.'
  spec.description   = 'White Source agent to sync gems'
  spec.homepage      = 'https://github.com/whitesource/ruby-plugin'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.executables   = %w(wss_agent)
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry', '~> 0.10.4'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'webmock', '~> 2.1'
  spec.add_development_dependency 'timecop', '~> 0.8.1'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'vcr', '~> 3.0', '>= 3.0.3'

  spec.add_dependency 'thor', '~> 0.19', '>= 0.19.1'
  spec.add_dependency 'yell', '~> 2.0', '>= 2.0.5'
  spec.add_dependency 'excon', '~> 0.45'
  spec.add_dependency 'faraday', '~> 0.12'
  spec.add_dependency 'faraday_middleware', '~> 0.11.0.1'
  spec.add_dependency 'awesome_print', '~> 1.6', '>= 1.6.1'
  spec.add_dependency 'multi_json', '~> 1.12', '>= 1.12.1'
  spec.add_dependency 'psych', '~> 2.2', '>= 2.2.4'
end
