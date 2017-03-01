require 'test_helper'

class RoboticFarmControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
