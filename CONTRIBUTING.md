# Contributing

## Running specs

ActionArgs has several Bundler Gemfiles, each of which bundles different version of Rails.

    % ls gemfiles/*.gemfile
    gemfiles/rails_40.gemfile gemfiles/rails_41.gemfile

Via BUNDLE_GEMFILE ENV variable, you can tell Bundler which version of Rails to bundle.

    $ BUNDLE_GEMFILE=gemfiles/rails_40.gemfile bundle ex rake spec

Simply executing this command would probably run all tests against each version of Rails:

    % rake spec:all
