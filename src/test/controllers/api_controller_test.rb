require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get encrypt" do
    get :encrypt
    assert_response :success
  end

  test "should get decrypt" do
    get :decrypt
    assert_response :success
  end

end
