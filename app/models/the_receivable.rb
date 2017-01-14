module TheReceivable
  extend ActiveSupport::Concern

  included do
    has_many :received_notifications, as: 'receiver', class_name: 'Notification', dependent: :destroy
  end

  def unread_count
    Rails.cache.read("receiver_#{self.id}_unread") || 0
  end

end
