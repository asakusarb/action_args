# frozen_string_literal: true

using ActionArgs::ParamsHandler

module ActionArgs
  module ActiveSupport
    if Rails.version >= '5.1'
      module CallbackParameterizer
        # Extending AS::Callbacks::Callback's `make_lambda` not just to call specified
        # method but to call the method with method parameters taken from `params`.
        # This would happen only when
        # * the target object is_a ActionController object
        # * the filter was not defined via lambda
        def make_lambda
          lambda do |target, value, &block|
            target, block, method, *arguments = expand(target, value, block)

            if (ActionController::Base === target) && (method != :instance_exec) && arguments.empty?
              target.strengthen_params! method
              arguments, keyword_arguments = target.extract_method_arguments_from_params method
              if keyword_arguments.any?
                target.send(method, *arguments, **keyword_arguments, &block)
              else
                target.send(method, *arguments, &block)
              end
            else
              target.send(method, *arguments, &block)
            end
          end
        end
      end
      ::ActiveSupport::Callbacks::CallTemplate.prepend ActionArgs::ActiveSupport::CallbackParameterizer
    else
      # For Rails 4 & 5.0
      module CallbackParameterizerLegacy
        # Extending AS::Callbacks::Callback's `make_lambda` not just to call specified
        # method but to call the method with method parameters taken from `params`.
        # This would happen only when
        # * the filter was defined in Symbol form
        # * the target object is_a ActionController object
        def make_lambda(filter)
          if Symbol === filter
            lambda do |target, _, &blk|
              if ActionController::Base === target
                target.strengthen_params! filter
                values, kwargs_values = target.extract_method_arguments_from_params filter
                values << kwargs_values if kwargs_values.any?
                target.send filter, *values, &blk
              else
                target.send filter, &blk
              end
            end
          else
            super
          end
        end
      end
      ::ActiveSupport::Callbacks::Callback.prepend ActionArgs::ActiveSupport::CallbackParameterizerLegacy
    end
  end
end
