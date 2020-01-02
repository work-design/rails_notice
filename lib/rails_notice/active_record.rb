module RailsNotice::ActiveRecord

  # notify_mailer
  # notify_method
  # only
  # except
  # cc_emails
  # tr_values
  def acts_as_notify(code = 'default', **options)
    include RailsNotice::Notifiable
    RailsNotice.notifiable_types[self.name].merge! code.to_sym => options
  end

end

ActiveSupport.on_load :active_record do
  extend RailsNotice::ActiveRecord
end
