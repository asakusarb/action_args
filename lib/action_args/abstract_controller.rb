module AbstractController
  class Base
    if defined? ActionController::StrongParameters
      def send_action(method_name, *args)
        return send method_name, *args unless args.empty?

        target_model_name = self.class.name.sub(/.+::/, '').sub(/Controller$/, '').singularize.underscore.to_sym
        permitted_attributes = self.class.instance_variable_get '@permitted_attributes'

        method_parameters = method(method_name).parameters
        method_parameters.each do |type, key|
          if (key == target_model_name) && permitted_attributes
            params[key] = params.require(key).try :permit, *permitted_attributes
          end
        end

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
        @permitted_attributes = attributes
      end
    # no StrongParameters
    else
      def send_action(method_name, *args)
        return send method_name, *args unless args.empty?

        values = ActionArgs::ParamsHandler.extract_method_arguments_from_params method(method_name).parameters, params
        send method_name, *values
      end
    end
  end
end
