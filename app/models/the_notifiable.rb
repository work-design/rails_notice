module TheNotifiable

  included do
    Notification.belongs_to :receiver, class_name: name, foreign_key: 'receiver_id', optional: true, inverse_of: :notifications
    has_many :notifications, dependent: :destroy
  end

  def unread_count
    Rails.cache.read("user_#{self.id}_unread") || 0
  end

end
