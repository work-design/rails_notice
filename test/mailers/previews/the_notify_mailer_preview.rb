# http://localhost:3000/rails/mailers/the_notify_mailer_preview
class TheNotifyMailerPreview < ActionMailer::Preview

  def notify
    @notification = Notification.first
    TheNotifyMailer.notify @notification.id
  end

end