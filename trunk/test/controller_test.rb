ENV['NO_INIT'] = 'true'
require File.join(File.dirname(__FILE__), '../test_init')
require 'test_help'
require 'fileutils'

class TestController < ActionController::Base  
  def rescue_action(e) raise e end
  
  def some_action
    render :text => url_for(params)
  end

end

class ControllerTest < Test::Unit::TestCase

  def setup
    @controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # def test_incorrect_encoding_for_nested_hash_params
  #   get :some_action, :some => { :nested => :hash }
  #   assert_equal "http://test.host/test/some_action?some=nestedhash", @response.body
  # end

  def test_correct_encoding_for_nested_hash_params
    get :some_action, :some => { :nested => :hash }
    assert_equal "http://test.host/test/some_action?some%5Bnested%5D=hash", @response.body
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
  
  
  private
  
  def isolate
    fork do
      yield
    end
    Process.wait
  end
end