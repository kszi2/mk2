require "test_helper"

class ControlPanelControllerTest < ActionDispatch::IntegrationTest
  test "should get view" do
    get control_panel_view_url
    assert_response :success
  end
end
