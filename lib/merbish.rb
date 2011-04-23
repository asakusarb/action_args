require File.join(File.dirname(__FILE__), 'merbish/abstract_controller')

module Merbish
  class Railtie < ::Rails::Railtie
    if config.respond_to? :app_generators
      config.app_generators.scaffold_controller = :merbish_scaffold_controller
    else
      config.generators.scaffold_controller = :merbish_scaffold_controller
    end
  end
end
