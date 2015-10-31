require 'test_helper'

class ScoresControllerTest < ActionController::TestCase
  test 'should get home' do
    get :home
    assert_response :success
  end

  test 'should get map' do
    get :map
    assert_response :success
  end

  test 'should get player' do
    get :player
    assert_response :success
  end

  test 'should get recent_wrs' do
    get :recent_wrs
    assert_response :success
  end
end
