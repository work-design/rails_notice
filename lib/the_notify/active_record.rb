module TheNotify::ActiveRecord

  # notify_mailer
  # notify_method
  # only
  # except
  # cc_emails
  def acts_as_notify(code = 'default', **options)
    @@notifies ||= {}
    @@notifies[code.to_sym] = options
  end

  def notifies
    @@notifies
  end

end

ActiveSupport.on_load :active_record do
  extend TheNotify::ActiveRecord
end