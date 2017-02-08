class NotificationJob < ApplicationJob
  queue_as :default

  def perform(notification_id)
    notify = Notification.find(notification_id)
    if notify.receiver
      ActionCable.server.broadcast "receiver:#{notify.receiver_id}",
                                   id: notify.id,
                                   body: notify.body,
                                   count: notify.unread_count,
                                   link: notify.link
    end
  end

end