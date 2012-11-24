module ActionController
  class Base
    def send_action(method_name, *args)
      return send method_name, *args unless args.blank?

      values = if defined? ActionController::StrongParameters
        method(method_name).parameters.map(&:last).map {|k| params.require(k)}
      else
        method(method_name).parameters.map(&:last).map {|k| params[k]}
      end
      send method_name, *values
    end
  end
end
