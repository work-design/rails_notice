require 'test_helper'
class Notice::Admin::AnnunciatesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @notice_admin_annunciate = create notice_admin_annunciates
  end

  test 'index ok' do
    get admin_annunciates_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_annunciate_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Annunciate.count') do
      post admin_annunciates_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_annunciate_url(@notice_admin_annunciate)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_annunciate_url(@notice_admin_annunciate)
    assert_response :success
  end

  test 'update ok' do
    patch admin_annunciate_url(@notice_admin_annunciate), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Annunciate.count', -1) do
      delete admin_annunciate_url(@notice_admin_annunciate)
    end

    assert_response :success
  end

end
