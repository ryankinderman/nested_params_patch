class Array
  
  def to_param
    self.collect { |element| element.respond_to?(:to_param) ? element.to_param : element }
  end

end