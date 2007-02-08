require File.join(File.dirname(__FILE__), '../test_init')

class HashTest < Test::Unit::TestCase
	def test_flatten_with_unnested
		options = {
			:first_key => 1, 
			:second_key => 2
		}
		
		params = options.flatten(:whatever)
		
		assert params.include?(:'whatever[first_key]')
		assert_equal 1, params[:'whatever[first_key]']
		assert params.include?(:'whatever[second_key]')
		assert_equal 2, params[:'whatever[second_key]']
	end
	
	def test_flatten_with_single_nesting
		options = {
			:first_key => 1, 
			:second_key => {
				:third_key => 3
			}
		}
		
		params = options.flatten(:whatever)
		
		assert_equal 2, params.size
		assert_equal 1, params[:'whatever[first_key]']
		assert_equal 3, params[:'whatever[second_key][third_key]']
	end

	def test_flatten_with_double_nesting
		options = {
			:first_key => 1, 
			:second_key => {
				:third_key => 3,
				:fourth_key => {
					:fifth_key => 5
				}
			}
		}
		
		params = options.flatten(:whatever)
		
		assert_equal 3, params.size
		assert_equal 1, params[:'whatever[first_key]']
		assert_equal 3, params[:'whatever[second_key][third_key]']
		assert_equal 5, params[:'whatever[second_key][fourth_key][fifth_key]']
	end

	def test_parameterize
		options = {
			:first_key => 1, 
			:second_key => {
				:third_key => 3,
				:fourth_key => {
					:fifth_key => 5
				}
			}
		}		
		expected_hash = {
			:first_key => 1, 
			:'second_key[third_key]' => 3,
			:'second_key[fourth_key][fifth_key]' => 5
		}

		actual = {}
		options.parameterize { |k, v| actual[k] = v }
		
		assert_equal expected_hash, actual
	end

  def test_to_param
    options = {
      :key => [
        {
          :something => {
            :nested => '1'
          }
        }
      ]
    }
        
    assert_equal [{:'something[nested]' => '1'}], options.to_param[:key]
  end
	
  def test_to_query_string
    options = {
      :key1 => 1,
      :key2 => 2
    }
    
    assert_query_string 'key1=1', 'key2=2', options.to_query_string
  end

  def test_to_query_string_with_nested_hash
    options = {
      :single_nested => {
        :key1 => 1,
      }
    }

    assert_equal '?single_nested[key1]=1', options.to_query_string
  end

  def test_to_query_string_with_hash_of_array
    options = {
      :key => [1, 2]
    }
    
    assert_query_string 'key[]=1', 'key[]=2', options.to_query_string
  end

  
  def test_to_query_string_with_hash_of_array_of_hash
    options = {
      :key => [:something => 1, :foo => 'bar']
    }

    assert_query_string 'key[][foo]=bar', 'key[][something]=1', options.to_query_string
  end

  def test_to_query_string_with_hash_of_array_of_nested_hash
    options = {
      :key => [:something => {:foo => 'bar'}]
    }
    
    assert_equal '?key[][something][foo]=bar', options.to_query_string
  end

  def test_to_query_string_with_hash_of_array_of_array
    options = {
      :key => [[:something => {:foo => 'bar'}]]
    }
    
    assert_equal '?key[][][something][foo]=bar', options.to_query_string
  end
  
  def test_to_query_string_with_nil_value
    options = {
      :key => nil
    }
    
    assert_equal '?key=', options.to_query_string    
  end
	
  def test_to_query_string_with_empty_hash
    assert_equal '', {}.to_query_string
  end
  
  def test_to_query_string_with_boolean
    options = {
      :key => true
    }
    
    assert_equal '?key=true', options.to_query_string
  end

	
	private
	
	def assert_query_string(*args)
	  actual = args.delete_at(args.size - 1)
	  params = []
	  args.size.times { |i| params << '(.*)' }
	  query_str = "^\\?#{params.join('\&')}$"
	  
	  match_data = actual.match(query_str)
	  assert match_data, "Query String '#{actual}' does not match pattern /#{query_str}/"

	  args.each do |expected|
	    assert match_data.captures.include?(expected), "Query String '#{actual}' does not contain string '#{expected}'"
    end
  end	
	
end