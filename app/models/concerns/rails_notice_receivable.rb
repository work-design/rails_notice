module RailsNoticeReceivable
  extend ActiveSupport::Concern

  included do
    has_many :received_notifications, as: 'receiver', class_name: 'Notification', dependent: :destroy
    has_one :notification_setting, as: 'receiver', dependent: :destroy
  end

  def unread_count
    Rails.cache.read("#{self.class.name}_#{self.id}_unread") || 0
  end

  def endearing_name
    name
  end

end
