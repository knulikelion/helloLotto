require 'test_helper'

class LottosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get lottos_index_url
    assert_response :success
  end

end
