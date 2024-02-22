require "test_helper"

class Api::ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_products_index_url
    assert_response :success
  end

  test "should get search" do
    get api_products_search_url
    assert_response :success
  end

  test "should get create" do
    get api_products_create_url
    assert_response :success
  end

  test "should get update" do
    get api_products_update_url
    assert_response :success
  end

  test "should get destroy" do
    get api_products_destroy_url
    assert_response :success
  end

  test "should get approval_queue" do
    get api_products_approval_queue_url
    assert_response :success
  end

  test "should get approve" do
    get api_products_approve_url
    assert_response :success
  end

  test "should get reject" do
    get api_products_reject_url
    assert_response :success
  end
end
