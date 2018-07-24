class TheNotifyMailer < ApplicationMailer
  add_template_helper(RailsCom::FormatHelper)

  def notify(notification_id)
    @notification = Notification.find(notification_id)
    unless @notification.receiver.respond_to?(:email) && @notification.receiver.email
      return
    end
    if @notification.receiver.respond_to?(:locale)
      I18n.locale = self.receiver.locale
    end

    mail to: @notification.receiver.email,
         cc: @notification.cc_emails,
         subject: @notification.title || 'Notification'
  end

end