module TheReceivable
  extend ActiveSupport::Concern

  included do
    Notification.belongs_to :receiver, class_name: name, foreign_key: 'receiver_id', optional: true, inverse_of: :notifications
    has_many :received_notifications, class_name: 'Notification', foreign_key: 'receiver_id', dependent: :destroy
  end

  def unread_count
    Rails.cache.read("receiver_#{self.id}_unread") || 0
  end

end
