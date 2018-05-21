class TheNotifyMailer < ApplicationMailer
  add_template_helper(RailsCom::FormatHelper)

  def notify(notification_id)
    @notification = Notification.find(notification_id)

    return unless @notification.receiver.respond_to?(:email) && @notification.receiver.email

    mail to: @notification.receiver.email,
         cc: @notification.cc_emails,
         subject: @notification.title || 'Notification'
  end

end