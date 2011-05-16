require File.join(File.dirname(__FILE__), 'action_args/abstract_controller')

module ActionArgs
  class Railtie < ::Rails::Railtie
    if config.respond_to? :app_generators
      config.app_generators.scaffold_controller = :action_args_scaffold_controller
    else
      config.generators.scaffold_controller = :action_args_scaffold_controller
    end
  end
end
