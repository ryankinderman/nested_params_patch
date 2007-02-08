# NOTE:
# This test case illustrates the high-level issues solved by the plugin. The unit tests that are 
# not commented out are the ones that demonstrate correct behavior. 
# 
# The unit tests that *are* commented out demonstrate the incorrect behavior that was fixed. To 
# see the incorrect behavior demonstrated, comment out the contents of /init.rb and uncomment out 
# the unit tests starting with test_incorrect*, then run those tests. Be sure to put everything
# back to the way it was after you're done poking around, though :)

ENV['NO_INIT'] = 'true'
require File.join(File.dirname(__FILE__), '../test_init')
require 'test_help'
require 'fileutils'

class TestController < ActionController::Base  
  def rescue_action(e) raise e end
  
  def primer; render :nothing => true; end
  def some_action
    render :text => url_for(params)
  end

end

class ControllerTest < Test::Unit::TestCase

  def setup
    @controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    ActionController::Routing::Routes.draw do |map|
      map.some_action_test '/test/some_action', :controller => 'test', :action => 'some_action'
      map.connect ':controller/:action/:id'
    end
    
    get :primer
  end

  # def test_incorrect_encoding_for_nested_hash_params
  #   get :some_action, :some => { :nested => :hash }
  #   assert_equal "http://test.host/test/some_action?some=nestedhash", @response.body
  # end

  def test_correct_encoding_for_nested_hash_params
    get :some_action, :some => { :nested => :hash }
    assert_equal "http://test.host/test/some_action?some%5Bnested%5D=hash", @response.body
  end

  # def test_incorrect_encoding_for_named_route
  #   assert_equal 'http://test.host/test/some_action?some=nestedhash', some_action_test_url(:some => { :nested => :hash })
  # end

  def test_correct_encoding_for_nested_hash_params_with_named_route
    assert_equal 'http://test.host/test/some_action?some%5Bnested%5D=hash', some_action_test_url(:some => { :nested => :hash })
  end

  # def test_incorrect_encoding_for_array_params
  #   get :some_action, :an_array => [1, 2]
  #   assert_equal "http://test.host/test/some_action?an_array=1%2F2", @response.body
  #   assert_equal ActionController::Routing::PathSegment::Result, @request.query_parameters[:an_array].class
  # end

  def test_correct_encoding_for_array_params
    get :some_action, :an_array => [1, 2]
    assert_equal "http://test.host/test/some_action?an_array[]=1&an_array[]=2", @response.body
    assert_equal ActionController::Routing::PathSegment::Result, @request.query_parameters[:an_array].class
  end

  # def test_incorrect_encoding_for_array_params_with_named_route
  #   assert_equal 'http://test.host/test/some_action?an_array=1%2F2', some_action_test_url(:an_array => [1, 2])
  # end
  
  def test_correct_encoding_for_array_params_with_named_route
    assert_equal 'http://test.host/test/some_action?an_array[]=1&an_array[]=2', some_action_test_url(:an_array => [1, 2])
  end
  
  
  private
  
  def isolate
    fork do
      yield
    end
    Process.wait
  end
end