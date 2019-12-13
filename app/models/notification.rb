class Notification < ApplicationRecord
  include RailsNotice::Notification
  include RailsNoticeSend::Socket
end unless defined? Notification
