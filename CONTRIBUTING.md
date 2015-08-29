# Contributing

## Running tests

ActionArgs has several Bundler Gemfiles, each of which bundles different version of Rails.

    % ls gemfiles/*.gemfile
    gemfiles/rails_41.gemfile gemfiles/rails_42.gemfile rails_edge.gemfile


Via BUNDLE_GEMFILE ENV variable, you can tell Bundler which version of Rails to bundle.

    $ BUNDLE_GEMFILE=gemfiles/rails_42.gemfile bundle ex rake test

Simply executing this command would probably run all tests against each version of Rails:

    % rake test:all
