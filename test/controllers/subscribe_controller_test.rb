require 'test_helper'

class SubscribeControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get subscribe_create_url
    assert_response :success
  end

end
