begin
  require 'strong_parameters'
rescue LoadError
end
require 'action_args/params_handler'
require 'action_args/abstract_controller'
if ActionArgs.respond_to? :prepend
  require 'action_args/callbacks'
else
  require 'action_args/legacy/callbacks'
end

module ActionArgs
  class Railtie < ::Rails::Railtie
    if config.respond_to? :app_generators
      config.app_generators.scaffold_controller = :action_args_scaffold_controller
    else
      config.generators.scaffold_controller = :action_args_scaffold_controller
    end
  end
end
