class NotificationSetting < ApplicationRecord
  include RailsNotice::NotificationSetting
end unless defined? NotificationSetting
