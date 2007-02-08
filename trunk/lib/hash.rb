class Hash
  
  def to_param
    params = {}
    parameterize do |key, value|
      params[key] = process_option_param_value(value)
    end
    params
  end

	def flatten(superkey)
		flattened_hash = {}
		self.each do |key, value|
			if value.is_a?(Hash)
				flattened_hash.merge!(value.flatten("#{superkey}[#{key}]".to_sym))
			else
				flattened_hash["#{superkey}[#{key}]".to_sym] = value
			end
		end
		flattened_hash
	end
	
	def parameterize
		self.each do |k, value|
			if value.is_a?(Hash)
				value.flatten(k).each { |fk, fv| yield fk, fv }
			else
				yield k, value
			end
		end				
	end

	def to_query_string
	  elements = []
	  self.each do |key, value|
	    elements += process_pair(CGI.escape(key.to_s), value)
	  end
	  elements.empty? ? '' : "?#{elements.join('&')}"
  end


  private

  def process_pair(key, value)
    elements = []
    if value.is_a?(Array)
      value.each do |element|
        elements += process_pair((key.to_s + '[]').to_sym, element)
      end
    elsif value.is_a?(Hash)
      value.flatten(key).each do |fk, fv|
        elements += process_pair(fk, fv)
      end
    else
      elements << "#{key.to_s}=#{CGI.escape(process_option_param_value(value).to_s)}"
    end
    elements
  end
  
  def process_option_param_value(value)
    if value.respond_to?(:to_param)
      val = value.to_param
    else
      val = value
    end
    val.nil? ? '' : val
  end

end