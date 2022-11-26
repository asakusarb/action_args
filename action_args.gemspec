# -*- encoding: utf-8 -*-
# frozen_string_literal: true

$:.push File.expand_path("../lib", __FILE__)
require 'action_args/version'

Gem::Specification.new do |s|
  s.name        = 'action_args'
  s.version     = ActionArgs::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Akira Matsuda']
  s.email       = ['ronnie@dio.jp']
  s.homepage    = 'http://asakusa.rubyist.net/'
  s.license     = 'MIT'
  s.metadata = {
    'source_code_uri' => 'https://github.com/asakusarb/action_args'
  }
  s.summary     = 'Controller action arguments parameterizer for Rails 4+ & Ruby 2.0+'
  s.description = 'Rails plugin gem that supports Merbish style controller action arguments.'

  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.require_paths = ["lib"]

  s.add_development_dependency 'actionpack'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'test-unit-rails'
end
