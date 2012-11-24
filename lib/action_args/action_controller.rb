module ActionController
  class Base
    def send_action(method_name, *args)
      return send method_name, *args unless args.blank?

      values = method(method_name).parameters.map(&:last).map {|k| params[k]}
      send method_name, *values
    end
  end
end
