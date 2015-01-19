module ActiveSupport
  module Callbacks
    class Callback
      # Extending AS::Callbacks::Callback's `make_lambda` not just to call specified
      # method but to call the method with method parameters taken from `params`.
      # This would happen only when
      # * the filter was defined in Symbol form
      # * the target object is_a ActionController object
      def make_lambda_with_method_parameters(filter)
        if Symbol === filter
          lambda do |target, _|
            if ActionController::Base === target
              meth = target.method filter
              method_parameters = meth.parameters
              ActionArgs::ParamsHandler.strengthen_params!(target.class, method_parameters, target.params)
              values = ActionArgs::ParamsHandler.extract_method_arguments_from_params method_parameters, target.params
              target.send filter, *values
            else
              target.send filter
            end
          end
        else
          make_lambda_without_method_parameters filter
        end
      end
      alias_method_chain :make_lambda, :method_parameters
    end
  end
end
