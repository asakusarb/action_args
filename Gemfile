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

rails_version = ENV['RAILS_VERSION'] || '∞'

platforms :ruby do
  gem 'sqlite3', rails_version >= '5.1' ? '>= 1.4' : '< 1.4'
end
platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
end

gem 'nokogiri', RUBY_VERSION < '2.1' ? '~> 1.6.0' : '>= 1.7'
gem 'loofah', RUBY_VERSION < '2.5' ? '~> 2.20.0' : '>= 2.20'

gem 'selenium-webdriver' if rails_version >= '6.1'

gem 'net-smtp' if RUBY_VERSION >= '3.1'
