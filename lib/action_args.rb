require 'action_args/params_handler'
require 'action_args/abstract_controller'
require 'action_args/callbacks'

module ActionArgs
  class Railtie < ::Rails::Railtie
    config.app_generators.scaffold_controller = :action_args_scaffold_controller
  end
end
