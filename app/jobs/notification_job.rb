class NotificationJob < ApplicationJob
  queue_as :default

  def perform(notification_id)
    notify = Notification.find(notification_id)
    notify.send
  end

end
