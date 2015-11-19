module ActionArgs
  module ParamsHandler
    refine AbstractController::Base do
      # converts the request params Hash into an Array to be passed into the target Method
      def extract_method_arguments_from_params(method_name)
        method_parameters = method(method_name).parameters
        kwargs, missing_required_params = {}, []
        parameter_names = method_parameters.map(&:last)
        method_parameters.reverse_each do |type, key|
          case type
          when :req
            missing_required_params << key unless params.has_key? key
            next
          when :keyreq
            if params.has_key? key
              kwargs[key] = params[key]
            else
              missing_required_params << key
            end
          when :key
            kwargs[key] = params[key] if params.has_key? key
          when :opt
            break if params.has_key? key
          end
          # omitting parameters that are :block, :rest, :opt without a param, and :key without a param
          parameter_names.delete key
        end
        if missing_required_params.any?
          raise ActionController::BadRequest.new(:required, ArgumentError.new("Missing required parameters at #{self.class.name}##{method_name}: #{missing_required_params.join(', ')}"))
        end

        values = parameter_names.map {|k| params[k]}
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
          if (key == target_model_name) && permitted_attributes
            params.require(key) if %i[req keyreq].include?(type)
            params[key] = params[key].try :permit, *permitted_attributes
          end
        end
      end
    end
  end
end
