# frozen_string_literal: true

require_relative 'params_handler'
using ActionArgs::ParamsHandler

module ActionArgs
  module AbstractControllerMethods
    def send_action(method_name, *args)
      unless args.empty?
        kwargs = args.extract_options!
        if kwargs.any?
          return super(method_name, *args, **kwargs)
        else
          return super
        end
      end

      return super if !defined?(params) || params.nil?

      strengthen_params! method_name
      values, kwargs_values = extract_method_arguments_from_params method_name
      if kwargs_values.any?
        super method_name, *values, **kwargs_values
      else
        super method_name, *values
      end
    end
  end

  module AbstractControllerClassMethods
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
    def permits(*attributes, model_name: nil, **kw_attributes)
      @permitted_attributes, @permitting_model_name = attributes << kw_attributes, model_name
    end
  end
end

AbstractController::Base.send :prepend, ActionArgs::AbstractControllerMethods
AbstractController::Base.singleton_class.send :include, ActionArgs::AbstractControllerClassMethods
