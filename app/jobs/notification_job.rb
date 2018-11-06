class NotificationJob < ApplicationJob
  queue_as :default

  def perform(notification_id)
    notify = Notification.find(notification_id)
    if notify.receiver
      ActionCable.server.broadcast "#{notify.receiver_type}:#{notify.receiver_id}",
                                            id: notify.id,
                                            body: notify.body,
                                            count: notify.unread_count,
                                            link: notify.link,
                                            showtime: notify.notification_setting&.showtime
      notify.update sent_at: Time.now
    end
  end

end
