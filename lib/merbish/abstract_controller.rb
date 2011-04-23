module AbstractController
  class Base
    def process_with_methopara(action, *args)
      return process_without_methopara action, *args unless args.blank?

      values = method(action).parameters.map(&:last).map {|k| params[k]}
      process_without_methopara action, *values
    end

    alias_method_chain :process, :methopara
  end
end
