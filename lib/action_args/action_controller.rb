module ActionController
  class Base
    class << self
      [:before, :after, :around].each do |callback|
        callback_name = if ActionPack::VERSION::MAJOR >= 4
                          "#{callback}_action"
                        else
                          "#{callback}_filter"
                        end
        define_method callback_name do |*names, &blk|
          options = names.extract_options!
          names.each do |name|
            super options do |controller|
              method_parameters = controller.class.instance_method(name).parameters
              ActionArgs::ParamsHandler.strengthen_params!(controller.class, method_parameters, params)
              values = ActionArgs::ParamsHandler.extract_method_arguments_from_params method_parameters, params
              controller.send name, *values
            end
          end
        end

        alias_method :"#{callback}_filter", :"#{callback}_action" if ActionPack::VERSION::MAJOR >= 4
      end
    end
  end
end
