# frozen_string_literal: true

require 'abstract_controller'

module ActionArgs
  module ParamsHandler
    refine AbstractController::Base do
      # converts the request params Hash into an Array to be passed into the target Method
      def extract_method_arguments_from_params(method_name)
        method_parameters = method(method_name).parameters
        kwargs, missing_required_params = {}, []
        parameter_names = []
        has_optional_parameter_in_params = false

        method_parameters.reverse_each do |type, key|
          trimmed_key = key.to_s.sub(/_params\z/, '').to_sym
          case type
          when :req
            if params.key? trimmed_key
              parameter_names.unshift key
            else
              missing_required_params << key
            end
          when :keyreq
            if params.key? trimmed_key
              kwargs[key] = params[trimmed_key]
            else
              missing_required_params << key
            end
          when :key
            kwargs[key] = params[trimmed_key] if params.key? trimmed_key
          when :opt
            if params.key? trimmed_key
              has_optional_parameter_in_params = true
              parameter_names.unshift key
            else
              parameter_names.unshift key if has_optional_parameter_in_params
            end
          when :rest
            parameter_names.unshift key
          end
          # :keyrest, :nokey, and :block take nothing from params
        end
        if missing_required_params.any?
          message = "Missing required parameters at #{self.class.name}##{method_name}: #{missing_required_params.join(', ')}"
          if Rails::VERSION::MAJOR >= 5
            raise ActionController::BadRequest.new message
          else
            raise ActionController::BadRequest.new :required, ArgumentError.new(message)
          end
        end

        values = parameter_names.map {|k| params[k.to_s.sub(/_params\z/, '').to_sym]}
        [values, kwargs]
      end

      # permits declared model attributes in the params Hash
      # note that this method mutates the given params Hash
      def strengthen_params!(method_name)
        # params that are not ActionController::Parameters (e.g. a parameterized mailer's Hash) need no permitting
        return unless params.respond_to?(:permit)

        # `permits` is inherited from the nearest ancestor that declared it
        permitting_class = self.class.ancestors.detect {|klass| klass.instance_variable_defined?(:@permitted_attributes) }
        return unless permitting_class

        # the model name cannot be deduced from an anonymous class
        model_name = permitting_class.instance_variable_get(:@permitting_model_name) || (self.class.name && self.class.name.sub(/.+::/, '').sub(/Controller$/, ''))
        return unless model_name

        target_model_name = model_name.singularize.underscore.tr('/', '_').to_sym
        permitted_attributes = permitting_class.instance_variable_get(:@permitted_attributes)

        method_parameters = method(method_name).parameters
        method_parameters.each do |type, key|
          trimmed_key = key.to_s.sub(/_params\z/, '').to_sym
          if trimmed_key == target_model_name
            params.require(trimmed_key) if %i[req keyreq].include?(type)
            params[trimmed_key] = params[trimmed_key].try :permit, *permitted_attributes if params.key? trimmed_key
          end
        end
      end
    end
  end
end
