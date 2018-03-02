class TheNotifyMailer < ApplicationMailer
  add_template_helper(RailsComHelper)

  def notify(notification_id)
    @notification = Notification.find(notification_id)

    return unless @notification.receiver.respond_to?(:email) && @notification.receiver.email

    mail(to: @notification.receiver.email, subject: @notification.title || 'Notification')
  end

end