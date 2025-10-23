require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_index_url
    assert_response :success
  end

  test "should get ingresos" do
    get dashboard_ingresos_url
    assert_response :success
  end

  test "should get consultas" do
    get dashboard_consultas_url
    assert_response :success
  end

  test "should get control_usuarios" do
    get dashboard_control_usuarios_url
    assert_response :success
  end
end
