module AbstractController
  class Base
      def send_action(method_name, *args)
        return send method_name, *args unless args.empty?
        return send method_name, *args unless defined?(params)

        method_parameters = method(method_name).parameters
        ActionArgs::ParamsHandler.strengthen_params!(self.class, method_parameters, params)
        values = ActionArgs::ParamsHandler.extract_method_arguments_from_params method_parameters, params
        send method_name, *values
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
