class TheNotifyMailer < ApplicationMailer
  add_template_helper(RailsCom::FormatHelper)

  def notify(notification_id)
    @notification = Notification.find(notification_id)
    unless @notification.receiver.respond_to?(:email) && @notification.receiver.email
      return
    end
    if @notification.receiver.respond_to?(:locale)
      I18n.locale = @notification.receiver.locale
    end

    mail_params = {to: @notification.receiver.email,
         cc: @notification.cc_emails,
         subject: @notification.title || 'Notification'}
    mail_params[:from] = @notification.sender.email if @notification.sender && @notification.sender.respond_to?(:email) && @notification.sender.email

    mail mail_params
  end

end
