class Notification < ApplicationRecord
  included RailsNotice::Notification
end unless defined? Notification
