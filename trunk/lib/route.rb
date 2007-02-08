module ActionController
  module Routing
    
    class Route
      def build_query_string(hash, only_keys=nil)
        # elements = []
        # 
        # only_keys ||= hash.keys
        # 
        # only_keys.each do |key|
        #   value = hash[key] or next
        #   key = CGI.escape key.to_s

        #   if value.class == Array
        #     key <<  '[]'
        #   else    
        #     value = [ value ] 
        #   end     
        #   value.each { |val| elements << "#{key}=#{CGI.escape(val.to_param.to_s)}" }
        # end     
        # 
        # query_string = "?#{elements.join("&")}" unless elements.empty?
        # query_string || ""

        only_keys ||= hash.keys
        excluded_keys = hash.keys.select { |key| !only_keys.include?(key) }
        excluded_keys.each { |key| hash.delete(key) }
        hash.to_query_string
      end    
    end
  
  end
end