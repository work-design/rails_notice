module RailsNoticePublishable
  extend ActiveSupport::Concern

  included do
    Annunciation.belongs_to :publisher, class_name: name, foreign_key: 'publisher_id', optional: true, inverse_of: :notifications
    has_many :published_notifications, class_name: 'Notification', foreign_key: 'publisher_id', dependent: :nullify
  end

end
