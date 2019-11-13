require 'test_helper'
class Notice::My::NotificationSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    User.include RailsNotice::Receiver
    account = create :account
    user = account.user
  
    post '/login', params: { identity: account.identity, password: user.password }
    follow_redirect!
  end

  test 'show ok' do
    get notification_setting_url
    assert_response :success
  end

  test 'edit ok' do
    get edit_notification_setting_url, xhr: true
    assert_response :success
  end

  test 'update ok' do
    patch notification_setting_url, params: { notification_setting: {  } }, xhr: true
    assert_response :success
  end
end
