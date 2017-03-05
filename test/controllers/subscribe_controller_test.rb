require 'test_helper'

class SubscribeControllerTest < ActionDispatch::IntegrationTest
  test "should respond" do
    post subscribe_url(symbol: "FB", price: 0.15)
    assert_response :success
  end

end
