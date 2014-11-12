require 'test_helper'

class PhotoAlbumControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
