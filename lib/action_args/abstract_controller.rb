module AbstractController
  class Base
    if defined? ActionController::StrongParameters
      def send_action(method_name, *args)
        return send method_name, *args unless args.empty?

        target_model_name = self.class.name.sub(/.+::/, '').sub(/Controller$/, '').singularize.underscore.to_sym
        permitted_attributes = self.class.instance_variable_get '@permitted_attributes'
        values, kwargs = [], {}
        method(method_name).parameters.reverse_each.drop_while {|type,key| type == :block || type == :opt && ! params.has_key?(key) }.reverse_each do |type, key|
          params.require key if type == :req
          val = if (key == target_model_name) && permitted_attributes
            params[key].try :permit, *permitted_attributes
          else
            params[key]
          end
          if type == :key
            kwargs[key] = val if params.has_key? key
          else
            values << val
          end
        end
        values << kwargs if kwargs.any?
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

        values, kwargs = [], {}
        method(method_name).parameters.reverse_each.drop_while {|type,key| type == :block || type == :opt && ! params.has_key?(key) }.reverse_each do |type, key|
          if type == :key
            kwargs[key] = params[key] if params.has_key? key
          else
            values << params[key]
          end
        end
        values << kwargs if kwargs.any?
        send method_name, *values
      end
    end
  end
end
