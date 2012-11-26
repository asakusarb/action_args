# load original rails scaffold_controller generator
require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'

# override rails genarator to switch template directory
module Rails
  module Generators
    class ActionArgsScaffoldControllerGenerator < ::Rails::Generators::ScaffoldControllerGenerator
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      source_root File.expand_path('../templates', __FILE__)
    end
  end
end

# load custom rspec generator
require 'generators/action_args/rspec/scaffold/scaffold_generator' if defined? ::RSpec::Rails
