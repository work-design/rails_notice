json.notifications @notifications, partial: 'notification', as: :notification
if current_user
  json.unread_count current_user.notification_setting.counters
end
json.partial! 'shared/pagination', items: @notifications
