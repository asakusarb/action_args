module AbstractController
  class Base
    if defined? ActionController::StrongParameters
      def send_action(method_name, *args)
        return send method_name, *args unless args.empty?

        target_model_name = self.class.name.sub(/.+::/, '').sub(/Controller$/, '').singularize.underscore.to_sym
        permitted_attributes = self.class.instance_variable_get '@permitted_attributes'
        kwargs = {}
        parameter_names = method(method_name).parameters.map(&:last)
        method(method_name).parameters.reverse_each do |type, key|
          if (key == target_model_name) && permitted_attributes
            params[key] = params.require(key).try :permit, *permitted_attributes
          end

          case type
          when :req
            params.require(key)
            next
          when :key
            kwargs[key] = params[key] if params.has_key? key
          when :opt
            break if params.has_key? key
          end
          parameter_names.delete key
        end

        values = parameter_names.map {|k| params[k]}
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

        kwargs = {}
        parameter_names = method(method_name).parameters.map(&:last)
        method(method_name).parameters.reverse_each do |type, key|
          case type
          when :req
            next
          when :key
            kwargs[key] = params[key] if params.has_key? key
          when :opt
            break if params.has_key? key
          end
          parameter_names.delete key
        end

        values = parameter_names.map {|k| params[k]}
        values << kwargs if kwargs.any?
        send method_name, *values
      end
    end
  end
end
