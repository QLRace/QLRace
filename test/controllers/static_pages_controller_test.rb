require 'test_helper'

class ServersControllerTest < ActionController::TestCase
  test "should get servers" do
    get :servers
    assert_response :success
  end

end
