require "test_helper"

class DemoPartialsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get demo_partials_new_url
    assert_response :success
  end

  test "should get edit" do
    get demo_partials_edit_url
    assert_response :success
  end
end
