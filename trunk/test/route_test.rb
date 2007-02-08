require File.join(File.dirname(__FILE__), '../test_init')

class RouteTest < Test::Unit::TestCase

	def test_build_query_string
		options = {	:key => [1, 2] }

		query_string = ActionController::Routing::Route.new().build_query_string(options)

		assert_equal "?key[]=1&key[]=2", query_string
	end

  class SubArray < Array
    def initialize(*args)
      args.each { |arg| self << arg }
    end
  end

	def test_build_query_string_with_subclass_of_array
		options = {	:key => SubArray.new(1, 2) }

		query_string = ActionController::Routing::Route.new().build_query_string(options)

		assert_equal "?key[]=1&key[]=2", query_string
	end

	def test_build_query_string_with_array_containing_hash
		options = {	:key => [{:something => 'value'}] }
	
		query_string = ActionController::Routing::Route.new().build_query_string(options)
	
		assert_equal "?key[][something]=value", query_string
	end
	
	def test_build_query_string_with_only_keys
	  options = {	:key => '2', :another_key => '1' }
	  
	  query_string = ActionController::Routing::Route.new().build_query_string(options, [:another_key])
	  
	  assert_equal "?another_key=1", query_string
  end

end