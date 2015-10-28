require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get servers" do
    get :servers
    assert_response :success
  end

end
