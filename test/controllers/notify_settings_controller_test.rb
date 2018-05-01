require 'test_helper'

class NotifySettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notify_setting = notify_settings(:one)
  end

  test "should get index" do
    get notify_settings_url
    assert_response :success
  end

  test "should get new" do
    get new_notify_setting_url
    assert_response :success
  end

  test "should create notify_setting" do
    assert_difference('NotifySetting.count') do
      post notify_settings_url, params: { notify_setting: {  } }
    end

    assert_redirected_to notify_setting_url(NotifySetting.last)
  end

  test "should show notify_setting" do
    get notify_setting_url(@notify_setting)
    assert_response :success
  end

  test "should get edit" do
    get edit_notify_setting_url(@notify_setting)
    assert_response :success
  end

  test "should update notify_setting" do
    patch notify_setting_url(@notify_setting), params: { notify_setting: {  } }
    assert_redirected_to notify_setting_url(@notify_setting)
  end

  test "should destroy notify_setting" do
    assert_difference('NotifySetting.count', -1) do
      delete notify_setting_url(@notify_setting)
    end

    assert_redirected_to notify_settings_url
  end
end
