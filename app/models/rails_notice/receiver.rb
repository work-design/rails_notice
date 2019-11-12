module RailsNotice::Receiver
  extend ActiveSupport::Concern
  included do
    has_many :notifications, as: :receiver, dependent: :delete_all
    has_many :received_notifications, as: :receiver, class_name: 'Notification'
    has_one :notification_setting, as: :receiver, dependent: :delete
    
    has_many :annunciates, through: :user_taggeds
  end

  def unread_count
    r = Rails.cache.read("#{self.class.name}_#{self.id}_unread") || 0
    r.to_i
  end
  
  def init_notifications
    notifications.where(notifiable_type: 'Annunciate', notifiable_id: self.annunciate_ids)
  end

  def notification_setting
    super || create_notification_setting
  end

  def endearing_name
    name
  end

end
