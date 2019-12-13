module RailsNoticeSend::Mailer
  
  def send_out
    super
    return unless email_enable?
    
    if notify_setting[:mailer_class]
      notify_method = notify_setting[:mailer_method] || 'notify'
      if sending_at
        notify_setting[:mailer_class].public_send(notify_method, self.notifiable_id).deliver_later(wait_until: sending_at)
      else
        notify_setting[:mailer_class].public_send(notify_method, self.notifiable_id).deliver_later
      end
    else
      if sending_at
        RailsNoticeMailer.notify(self.id).deliver_later(wait_until: sending_at)
      else
        RailsNoticeMailer.notify(self.id).deliver_later
      end
    end
  end

  def email_enable?
    if receiver.notification_setting.accept_email
      return true
    end
  
    if receiver.notification_setting.accept_email.is_a?(FalseClass)
      return false
    end
  
    RailsNotice.config.default_send_email
  end

  def cc_emails
    r = notify_setting.fetch(:cc_emails, []).map do |i|
      next i unless i.respond_to?(:call)
      i.call(notifiable)
    end
    r.flatten
  end
  
end
