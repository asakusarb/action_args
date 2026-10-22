# frozen_string_literal: true

require_relative 'params_handler'
using ActionArgs::ParamsHandler

module ActionArgs
  module AbstractControllerMethods
    def send_action(method_name, *args)
      return super unless args.empty?
      return super if !defined?(params) || params.nil?

      method_parameters = method(method_name).parameters
      strengthen_params! method_name, method_parameters
      values, kwargs_values = extract_method_arguments_from_params method_name, method_parameters
      if kwargs_values.any?
        super method_name, *values, **kwargs_values
      else
        super method_name, *values
      end
    end
    # passes the caller's kwargs through as kwargs, and a positional Hash as a positional Hash
    ruby2_keywords :send_action if respond_to?(:ruby2_keywords, true)
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

# Rails < 7 does not mark the methods that pass action arguments down to send_action with ruby2_keywords,
# and since Ruby 3.2 keyword arguments given to a mailer method arrive at send_action as a positional Hash.
# Mark them as Rails 7 does.
if (Rails::VERSION::MAJOR < 7) && Module.private_method_defined?(:ruby2_keywords)
  module ActionArgs
    def self.ruby2_keywords(mod, *method_names)
      method_names.each do |method_name|
        next unless mod.method_defined?(method_name, false) || mod.private_method_defined?(method_name, false)

        parameters = mod.instance_method(method_name).parameters
        next if parameters.none? {|type, _| type == :rest } || parameters.any? {|type, _| %i[key keyreq keyrest].include? type }

        mod.send :ruby2_keywords, method_name
      end
    end
  end

  ActionArgs.ruby2_keywords AbstractController::Base, :process, :process_action
  ActionArgs.ruby2_keywords AbstractController::Callbacks, :process_action

  ActiveSupport.on_load :action_mailer do
    ActionArgs.ruby2_keywords ActionMailer::Base, :process
    ActionArgs.ruby2_keywords ActionMailer::Rescuable, :process
    ActionArgs.ruby2_keywords ActionView::Rendering, :process
  end
end
