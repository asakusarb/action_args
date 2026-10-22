# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in action_args.gemspec
gemspec

if ENV['RAILS_VERSION'] == 'edge'
  gem 'rails', git: 'https://github.com/rails/rails.git'
elsif ENV['RAILS_VERSION']
  gem 'rails', "~> #{ENV['RAILS_VERSION']}.0"
else
  gem 'rails'
end

ruby_version = Gem::Version.new(RUBY_VERSION)
# nil for edge or the latest Rails
rails_version = Gem::Version.new(ENV['RAILS_VERSION']) if ENV['RAILS_VERSION'] && (ENV['RAILS_VERSION'] != 'edge')

platforms :ruby do
  if rails_version && (rails_version <= Gem::Version.new('5.0'))
    gem 'sqlite3', '< 1.4'
  elsif (rails_version && (rails_version < Gem::Version.new('8'))) || (ruby_version < Gem::Version.new('3'))
    gem 'sqlite3', '< 2'
  else
    gem 'sqlite3'
  end
end
platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
end

gem 'nokogiri', ruby_version < Gem::Version.new('2.1') ? '~> 1.6.0' : '>= 1.7'
gem 'loofah', ruby_version < Gem::Version.new('2.5') ? '~> 2.20.0' : '>= 2.20'

gem 'selenium-webdriver' if !rails_version || (rails_version >= Gem::Version.new('6.1'))

gem 'net-smtp' if ruby_version >= Gem::Version.new('3.1')

if ruby_version >= Gem::Version.new('3.3')
  gem 'bigdecimal'
  gem 'mutex_m'
end

gem 'benchmark' if ruby_version >= Gem::Version.new('4.0')
