json.notifications @notifications, partial: 'notification', as: :notification
json.partial! 'api/shared/pagination', items: @notifications
