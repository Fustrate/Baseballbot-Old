# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'baseballbot/version'

Gem::Specification.new do |spec|
  spec.name          = 'baseballbot'
  spec.version       = Baseballbot::VERSION
  spec.authors       = ['Steven Hoffman']
  spec.email         = ['git@fustrate.com']
  spec.summary       = 'A reddit bot for baseball subreddits'
  spec.description   = 'Posts and updates reddit gamechats and sidebars'
  spec.homepage      = 'http://github.com/Fustrate/Baseballbot'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^spec\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 2.14'

  spec.add_dependency 'mlb_gameday', '~> 0.0', '>= 0.0.11'
  # spec.add_dependency 'pg', '~> 0.17'
  # spec.add_dependency 'mysql2'
  spec.add_dependency 'snoo', '~> 0.1'
  spec.add_dependency 'thor', '~> 0.19'
end
