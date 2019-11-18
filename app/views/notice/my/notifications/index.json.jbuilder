json.notifications @notifications, partial: 'notification', as: :notification
if current_receiver
  json.unread_count current_receiver.notification_setting.counters
end
json.partial! 'pagination'
