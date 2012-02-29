# load original rspec scaffold generator
require 'generators/rspec/scaffold/scaffold_generator'

# override rspec genarator to switch template file
module Rspec
  module Generators
    class ScaffoldGenerator < Base
      source_paths << File.expand_path('../templates', __FILE__)

      def generate_controller_spec
        return unless options[:controller_specs]

        template 'action_args_controller_spec.rb',
                 File.join('spec/controllers', controller_class_path, "#{controller_file_name}_controller_spec.rb")
      end
    end
  end
end
