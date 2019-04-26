class Notification < ApplicationRecord
  include RailsNotice::Notification
end unless defined? Notification
