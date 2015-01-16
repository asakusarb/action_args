module ActionController
  class Base
    class << self
      # Redefining AS::Callback's `set_callback` to convert Symbol callbacks
      # into Procs that call given methods with method parameters taken from `params`.
      #
      # For example, if
      #   `before_action :set_user`
      # was defined in a controller, set_callback method receives parameters like this:
      #   {:name=>:process_action, :filter_list=>[:before, :set_user, {}]}
      # then this monkey-patch would convert `:set_user` to a Proc that calls `set_user`
      # method with proper params.
      def set_callback_with_symbol_to_proc(name, *filter_list, &block)
        if Symbol === filter_list[1]
          sym = filter_list[1]
          filter_list[1] = Proc.new {
            meth = method(sym)
            method_parameters = meth.parameters
            ActionArgs::ParamsHandler.strengthen_params!(self.class, method_parameters, params)
            values = ActionArgs::ParamsHandler.extract_method_arguments_from_params method_parameters, params
            send sym, *values
          }
        end
        set_callback_without_symbol_to_proc(name, *filter_list, &block)
      end

      alias_method_chain :set_callback, :symbol_to_proc
    end
  end
end
