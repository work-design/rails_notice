require 'test_helper'
class Notice::My::NotificationSettingsControllerTest < ActionDispatch::IntegrationTest

  setup do
    user = create :user
    @notification_setting = create :notification_setting
  end

  test 'index ok' do
    get notification_settings_url
    assert_response :success
  end

  test 'new ok' do
    get new_notification_setting_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('NotificationSetting.count') do
      post notification_settings_url, params: { notification_setting: {  } }
    end

    assert_redirected_to notification_setting_url(NotificationSetting.last)
  end

  test 'show ok' do
    get notification_setting_url(@notification_setting)
    assert_response :success
  end

  test 'edit ok' do
    get edit_notification_setting_url(@notification_setting)
    assert_response :success
  end

  test 'update ok' do
    patch notification_setting_url(@notification_setting), params: { notification_setting: {  } }
    assert_redirected_to notification_setting_url(@notification_setting)
  end

  test 'destroy ok' do
    assert_difference('NotificationSetting.count', -1) do
      delete notification_setting_url(@notification_setting)
    end

    assert_redirected_to notification_settings_url
  end
end
