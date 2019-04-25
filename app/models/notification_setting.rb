class NotificationSetting < ApplicationRecord
  included RailsNotice::NotificationSetting
end unless defined? NotificationSetting
