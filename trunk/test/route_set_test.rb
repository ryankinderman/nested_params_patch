require File.join(File.dirname(__FILE__), '../test_init')

class RouteSetTest < Test::Unit::TestCase

	def test_options_as_params
		options = {
			:first_key => 1, 
			:second_key => {
				:third_key => 3,
				:fourth_key => {
					:fifth_key => 5
				}
		}}
		params = ActionController::Routing::RouteSet.new().options_as_params(options)
		
		assert_equal '1', params[:first_key]
		assert_equal '3', params[:'second_key[third_key]']
		assert_equal '5', params[:'second_key[fourth_key][fifth_key]']
	end

  def test_options_as_params_with_array
    options = {:bleh => [1, 2]}
    
    params = ActionController::Routing::RouteSet.new().options_as_params(options)
    
    assert_equal [1, 2], params[:bleh]
  end

  class SubArray < Array
    def initialize(*args)
      args.each { |arg| self << arg }
    end
  end
  
  def test_options_as_params_with_subclass_of_array
    options = {:bleh => SubArray.new(1, 2)}

    params = ActionController::Routing::RouteSet.new().options_as_params(options)
    
    assert_equal options[:bleh], params[:bleh]    
  end
  
  def test_options_as_params_with_array_of_hashes
    options = {
      :key => [{:something => '1'}]
    }

    params = ActionController::Routing::RouteSet.new().options_as_params(options)
    
    assert_equal [{:something => '1'}], params[:key]
  end
  
  def test_options_as_params_with_array_of_nested_hashes
    options = {
      :key => [
        {
          :something => {
            :nested => '1'
          }
        }
      ]
    }
    
    params = ActionController::Routing::RouteSet.new().options_as_params(options)
    
    assert_equal [{:'something[nested]' => '1'}], params[:key]
  end
	
end