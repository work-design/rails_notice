json.notification @notification, partial: 'notification', as: :notification
if current_user
  json.unread_count current_user.notification_setting.counters
end
