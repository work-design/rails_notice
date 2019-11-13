require 'test_helper'
class Notice::Admin::AnnunciationsControllerTest < ActionDispatch::IntegrationTest
 
  setup do
    @annunciation = create :annunciation
  end

  test 'index ok' do
    get admin_annunciations_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_annunciation_url, xhr: true
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Annunciation.count') do
      post admin_annunciations_url, params: { annunciation: { body: @annunciation.body, state: @annunciation.state, title: @annunciation.title } }, xhr: true
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_annunciation_url(@annunciation)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_annunciation_url(@annunciation), xhr: true
    assert_response :success
  end

  test 'update ok' do
    patch admin_annunciation_url(@annunciation), params: { annunciation: { body: @annunciation.body, state: @annunciation.state, title: 'test1' } }, xhr: true
    
    @annunciation.reload
    assert_response 'test1', @annunciation.title
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Annunciation.count', -1) do
      delete admin_annunciation_url(@annunciation), xhr: true
    end

    assert_response :success
  end
end
