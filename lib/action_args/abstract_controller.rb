module AbstractController
  class Base
    def send_action(method_name, *args)
      return send method_name, *args unless args.blank?

      values = if defined? ActionController::StrongParameters
        target_model_name = self.class.name.sub(/Controller$/, '').singularize.underscore.to_sym
        permitted_attributes = self.class.instance_variable_get '@permitted_attributes'
        method(method_name).parameters.reject {|type, _| type == :block }.map(&:last).map do |key|
          if (key == target_model_name) && permitted_attributes
            params.require(key).permit(*permitted_attributes)
          else
            params.require(key)
          end
        end
      else
        method(method_name).parameters.reject {|type, _| type == :block }.map(&:last).map {|key| params[key]}
      end
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
  end
end
