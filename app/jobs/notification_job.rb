class NotificationJob < ApplicationJob
  queue_as :default

  def perform(notification_id)
    notify = Notification.find(notification_id)
    ActionCable.server.broadcast "user:#{notify.user_id}",
                                 body: notify.body,
                                 count: notify.unread_count,
                                 link: notify.link
  end

end