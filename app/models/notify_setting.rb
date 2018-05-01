class NotifySetting < ApplicationRecord
  serialize :only_verbose_columns, Array
  serialize :except_verbose_columns, Array
  serialize :cc_emails, Array


end
