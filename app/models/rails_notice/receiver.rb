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
  
  def apply_pending_annunciations(page: 1, per: 20)
    per = per.to_i > 0 ? per.to_i : 20
    page = page.to_i > 0 ? page.to_i : 1
    start = page.to_i * per

    all_annunciation_ids = annunciates.order(annunciation_id: :desc).offset(start).limit(per).pluck(:annunciation_id)
    made_annunciation_ids = notifications.where(notifiable_type: 'Annunciation').pluck(:notifiable_id)
    
    pending_annunciation_ids = all_annunciation_ids - made_annunciation_ids
    return if pending_annunciation_ids.blank?

    annunciations = Annunciation.where(id: pending_annunciation_ids)
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
        official: true,
        archived: false,
        created_at: annunciation.created_at,
        updated_at: annunciation.updated_at
      )
      r
    end
    
    Notification.insert_all annunciation_attributes
  end

  def notification_setting
    super || create_notification_setting
  end

  def endearing_name
    name
  end

end
