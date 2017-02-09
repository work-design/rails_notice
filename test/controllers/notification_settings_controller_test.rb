require 'test_helper'

class NotificationSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notification_setting = notification_settings(:one)
  end

  test "should get index" do
    get notification_settings_url
    assert_response :success
  end

  test "should get new" do
    get new_notification_setting_url
    assert_response :success
  end

  test "should create notification_setting" do
    assert_difference('NotificationSetting.count') do
      post notification_settings_url, params: { notification_setting: {  } }
    end

    assert_redirected_to notification_setting_url(NotificationSetting.last)
  end

  test "should show notification_setting" do
    get notification_setting_url(@notification_setting)
    assert_response :success
  end

  test "should get edit" do
    get edit_notification_setting_url(@notification_setting)
    assert_response :success
  end

  test "should update notification_setting" do
    patch notification_setting_url(@notification_setting), params: { notification_setting: {  } }
    assert_redirected_to notification_setting_url(@notification_setting)
  end

  test "should destroy notification_setting" do
    assert_difference('NotificationSetting.count', -1) do
      delete notification_setting_url(@notification_setting)
    end

    assert_redirected_to notification_settings_url
  end
end
