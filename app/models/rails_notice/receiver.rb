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
  
  def pending_annunciation_ids
    all_annunciation_ids - made_annunciation_ids
  end
  
  def made_annunciation_ids
    notifications.where(notifiable_type: 'Annunciation').pluck(:notifiable_id)
  end
  
  def all_annunciation_ids
    annunciates.pluck(:annunciation_id)
  end

  def apply_pending_annunciations
    Annunciation.where(id: pending_annunciation_ids).find_in_batches(batch_size: 20) do |annunciations|
      annunciation_attributes = annunciations.map do |annunciation|
        r = {}
        r.merge! annunciation.attributes.slice(:organ_id, :link)
        r.merge!(
          receiver_type: self.class.name,
          receiver_id: self.id,
          sender_type: annunciation.publisher_type,
          sender_id: annunciation.publisher_id,
          notifiable_type: annunciation.class.name,
          notifiable_id: annunciation.id,
          official: true
        )
        r
      end
      Notification.insert_all annunciation_attributes
    end
  end

  def notification_setting
    super || create_notification_setting
  end

  def endearing_name
    name
  end

end
