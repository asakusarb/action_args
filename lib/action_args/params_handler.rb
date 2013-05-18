module ActionArgs
  module ParamsHandler
    # converts the request params Hash into an Array to be passed into the target Method
    def self.extract_method_arguments_from_params(method_parameters, params)
      kwargs = {}
      parameter_names = method_parameters.map(&:last)
      method_parameters.reverse_each do |type, key|
        case type
        when :req
          next
        when :key
          kwargs[key] = params[key] if params.has_key? key
        when :opt
          break if params.has_key? key
        end
        # omitting parameters that are :block, :rest, :opt without a param, and :key without a param
        parameter_names.delete key
      end

      values = parameter_names.map {|k| params[k]}
      values << kwargs if kwargs.any?
      values
    end
  end
end
