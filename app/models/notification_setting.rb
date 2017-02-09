class NotificationSetting < ApplicationRecord
  belongs_to :receiver, polymorphic: true

end
