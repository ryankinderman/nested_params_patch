module ActionController
	module Routing
		
		class RouteSet

      def options_as_params(options)
        # options_as_params = options[:controller] ? { :action => "index" } : {}
        # options.each do |k, value|
        #   options_as_params[k] = value.to_param
        # end
        # options_as_params
        
        options_as_params = options[:controller] ? { :action => "index" } : {}
				options.parameterize do |param_key, param_value|
				  options_as_params[param_key] = process_option_param_value(param_value)
				end
        options_as_params
      end
      
      private
      
      def process_option_param_value(value)
        if value.is_a?(Array)
          value.collect! do |element| 
            if element.respond_to?(:parameterize)
              options_as_params(element)
            else
              element
            end
          end
          value
        else
				  value.to_param
			  end
      end

		end
	end	
end