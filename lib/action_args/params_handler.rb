# frozen_string_literal: true

module ActionArgs
  module ParamsHandler
    refine AbstractController::Base do
      # converts the request params Hash into an Array to be passed into the target Method
      def extract_method_arguments_from_params(method_name)
        method_parameters = method(method_name).parameters
        kwargs, missing_required_params = {}, []
        parameter_names = method_parameters.map(&:last)
        method_parameters.reverse_each do |type, key|
          trimmed_key = key.to_s.sub('_params', '').to_sym
          case type
          when :req
            missing_required_params << key unless params.key? trimmed_key
            next
          when :keyreq
            if params.key? trimmed_key
              kwargs[key] = params[trimmed_key]
            else
              missing_required_params << key
            end
          when :key
            kwargs[key] = params[trimmed_key] if params.key? trimmed_key
          when :opt
            break if params.key? trimmed_key
          end
          # omitting parameters that are :block, :rest, :opt without a param, and :key without a param
          parameter_names.delete key
        end
        if missing_required_params.any?
          message = "Missing required parameters at #{self.class.name}##{method_name}: #{missing_required_params.join(', ')}"
          if Rails.version > '5'
            raise ActionController::BadRequest.new message
          else
            raise ActionController::BadRequest.new :required, ArgumentError.new(message)
          end
        end

        values = parameter_names.map {|k| params[k.to_s.sub('_params', '').to_sym]}
        values << kwargs if kwargs.any?
        values
      end

      # permits declared model attributes in the params Hash
      # note that this method mutates the given params Hash
      def strengthen_params!(method_name)
        permitting_model_name = self.class.instance_variable_defined?(:@permitting_model_name) && self.class.instance_variable_get(:@permitting_model_name)
        target_model_name = (permitting_model_name || self.class.name.sub(/.+::/, '').sub(/Controller$/, '')).singularize.underscore.tr('/', '_').to_sym
        permitted_attributes = self.class.instance_variable_defined?(:@permitted_attributes) && self.class.instance_variable_get(:@permitted_attributes)

        method_parameters = method(method_name).parameters
        method_parameters.each do |type, key|
          trimmed_key = key.to_s.sub('_params', '').to_sym
          if (trimmed_key == target_model_name) && permitted_attributes
            params.require(trimmed_key) if %i[req keyreq].include?(type)
            params[trimmed_key] = params[trimmed_key].try :permit, *permitted_attributes if params.key? trimmed_key
          end
        end
      end
    end
  end
end
