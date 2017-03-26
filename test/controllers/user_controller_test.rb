require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "should get signup" do
    get signup_url
    assert_response :success
  end

end
