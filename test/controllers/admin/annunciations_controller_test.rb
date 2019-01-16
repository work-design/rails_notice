require 'test_helper'

class Admin::AnnunciationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_annunciation = admin_annunciations(:one)
  end

  test "should get index" do
    get admin_annunciations_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_annunciation_url
    assert_response :success
  end

  test "should create admin_annunciation" do
    assert_difference('Annunciation.count') do
      post admin_annunciations_url, params: { admin_annunciation: { body: @admin_annunciation.body, state: @admin_annunciation.state, title: @admin_annunciation.title } }
    end

    assert_redirected_to admin_annunciation_url(Annunciation.last)
  end

  test "should show admin_annunciation" do
    get admin_annunciation_url(@admin_annunciation)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_annunciation_url(@admin_annunciation)
    assert_response :success
  end

  test "should update admin_annunciation" do
    patch admin_annunciation_url(@admin_annunciation), params: { admin_annunciation: { body: @admin_annunciation.body, state: @admin_annunciation.state, title: @admin_annunciation.title } }
    assert_redirected_to admin_annunciation_url(@admin_annunciation)
  end

  test "should destroy admin_annunciation" do
    assert_difference('Annunciation.count', -1) do
      delete admin_annunciation_url(@admin_annunciation)
    end

    assert_redirected_to admin_annunciations_url
  end
end
