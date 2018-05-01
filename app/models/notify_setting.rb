class NotifySetting < ApplicationRecord
  serialize :only_verbose_columns, Array
  serialize :except_verbose_columns, Array
  serialize :cc_emails, Array


  def mailer_class
    notify_mailer.safe_constantize
  end

  def mailer_method

  end

end
