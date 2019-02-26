json.notifications @notifications, partial: 'notification', as: :notification
if current_user
  json.unread_count Notification.unread_count_details(current_user)
end
json.partial! 'api/shared/pagination', items: @notifications
