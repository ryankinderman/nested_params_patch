require File.join(File.dirname(__FILE__), '../test_init')

class ArrayTest < Test::Unit::TestCase  
  def test_to_param
    array = [1, 2]
    assert_equal ['1', '2'], array.to_param
  end
end