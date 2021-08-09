require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get items_about_url
    assert_response :success
  end

  test "should get index" do
    get items_index_url
    assert_response :success
  end

  test "should get show" do
    get items_show_url
    assert_response :success
  end

  test "should get top" do
    get items_top_url
    assert_response :success
  end

end
