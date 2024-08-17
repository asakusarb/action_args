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
  if rails_version <= '5.0'
    gem 'sqlite3', '< 1.4'
  elsif (rails_version <= '8') || (RUBY_VERSION < '3')
    gem 'sqlite3', '< 2'
  else
    gem 'sqlite3'
  end
end
platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
end

gem 'nokogiri', RUBY_VERSION < '2.1' ? '~> 1.6.0' : '>= 1.7'
gem 'loofah', RUBY_VERSION < '2.5' ? '~> 2.20.0' : '>= 2.20'

gem 'selenium-webdriver' if rails_version >= '6.1'

gem 'net-smtp' if RUBY_VERSION >= '3.1'

if RUBY_VERSION >= '3.3'
  gem 'bigdecimal'
  gem 'mutex_m'
end
