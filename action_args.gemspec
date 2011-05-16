# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'action_args/version'

Gem::Specification.new do |s|
  s.name        = 'action_args'
  s.version     = ActionArgs::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Akira Matsuda']
  s.email       = ['ronnie@dio.jp']
  s.homepage    = 'http://asakusa.rubyist.net/'
  s.summary     = 'Controller action arguments parameterizer for Rails 3 + Ruby 1.9'
  s.description = 'Rails 3 plugin gem that supports controller action arguments.'

  s.rubyforge_project = 'action_args'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
