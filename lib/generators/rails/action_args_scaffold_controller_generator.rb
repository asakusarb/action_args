# frozen_string_literal: true

# load original rails scaffold_controller generator
require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'

# override rails genarator to switch template directory
module Rails
  module Generators
    class ActionArgsScaffoldControllerGenerator < ::Rails::Generators::ScaffoldControllerGenerator
      argument :attributes, type: :array, default: [], banner: 'field:type field:type'
      source_root File.expand_path('../templates', __FILE__)

      private
        # Rack 3.1 renamed 422 from :unprocessable_entity to :unprocessable_content
        def unprocessable_status
          require 'rack/utils'
          ::Rack::Utils::SYMBOL_TO_STATUS_CODE.key?(:unprocessable_content) ? ':unprocessable_content' : ':unprocessable_entity'
        end
    end
  end
end
