class NotificationSetting < ApplicationRecord
  belongs_to :receiver, polymorphic: true
  serialize :notifiable_types, Array


  def notifiable_types
    super + TheNotify.config.default_notifiable_types
  end
end
