# frozen_string_literal: true
using ActionArgs::ParamsHandler

module ActionArgs
  module ActiveSupport
    # For Rails >= 5.1
    module CallbackParameterizer
      # Extending AS::Callbacks::Callback's `expand` not just to call specified
      # method but to call the method with method parameters taken from `params`.
      # This would happen only when
      # * the target object is_a ActionController object
      # * the filter was not defined via lambda
      def expand(*)
        target, block, method, *arguments = super

        if (ActionController::Base === target) && (method != :instance_exec) && arguments.empty?
          target.strengthen_params! method
          arguments = target.extract_method_arguments_from_params method
        end

        [target, block, method, *arguments]
      end
    end

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
              values = target.extract_method_arguments_from_params filter
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
  end
end

if Rails.version > '5.1'
  module ActiveSupport
    module Callbacks
      class CallTemplate
        prepend ActionArgs::ActiveSupport::CallbackParameterizer
      end
    end
  end
else
  module ActiveSupport
    module Callbacks
      class Callback
        prepend ActionArgs::ActiveSupport::CallbackParameterizerLegacy
      end
    end
  end
end
