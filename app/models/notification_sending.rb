class NotificationSending < ApplicationRecord
  include RailsNotice::NotificationSending
end unless defined? NotificationSending
