require_relative 'params_handler'

module AbstractController
  class Base
    include ActionArgs::ParamsHandler

    def send_action(method_name, *args)
      return send method_name, *args unless args.empty?
      return send method_name, *args unless defined?(params)

      send_with_method_parameters_from_params method_name
    end

    # You can configure StrongParameters' `permit` attributes using this DSL method.
    # The `permit` call will be invoked only against parameters having the resource
    # model name inferred from the controller class name.
    #
    #   class UsersController < ApplicationController
    #     permits :name, :age
    #
    #     def create(user)
    #       @user = User.new(user)
    #     end
    #   end
    #
    def self.permits(*attributes)
      if attributes.last.is_a?(Hash) && attributes.last.extractable_options? && attributes.last.has_key?(:model_name)
        options = attributes.pop
        @permitting_model_name = options[:model_name]
      end
      @permitted_attributes = attributes
    end
  end
end
