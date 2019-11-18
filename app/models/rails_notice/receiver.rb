module RailsNotice::Receiver
  extend ActiveSupport::Concern
  included do
    has_many :notifications, as: :receiver, dependent: :delete_all
    has_many :received_notifications, as: :receiver, class_name: 'Notification'
    has_one :notification_setting, as: :receiver, dependent: :delete
    
    has_many :annunciates, through: :user_taggeds
  end

  def unread_count
    r = notification_setting.fetch(:counters, {}).dig('total')
    r.to_i
  end
  
  def apply_pending_annunciations(page: nil, per: nil)
    all_annunciation_ids = annunciates.order(annunciation_id: :desc).page(page).per(per).pluck(:annunciation_id)
    made_annunciation_ids = notifications.unscoped.where(notifiable_type: 'Annunciation').pluck(:notifiable_id)

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
    
    Annunciation.increment_counter(:notifications_count, pending_annunciation_ids)
    Notification.insert_all annunciation_attributes
  end

  def notification_setting
    r = super || build_notification_setting
    if r.new_record?
      r.counters = compute_unread_count
      r.save
    end
    r
  end
  
  def compute_unread_count
    no = notifications.where(archived: false, read_at: nil)
    counters = {
      total: no.count,
      official: no.where(official: true).count
    }

    Notification.notifiable_types.map do |nt|
      counters.merge! nt.to_sym => no.where(notifiable_type: nt).count
    end

    all_annunciation_ids = annunciates.order(annunciation_id: :desc).pluck(:annunciation_id)
    made_annunciation_ids = notifications.unscoped.where(notifiable_type: 'Annunciation').pluck(:notifiable_id)

    added_count = (all_annunciation_ids - made_annunciation_ids).size
    [:total, :official, :'Annunciation'].each do |counter|
      counters[counter] += added_count
    end

    counters
  end
  
  def reset_unread_count
    notification_setting.update counters: compute_unread_count
  end

  def endearing_name
    name
  end

end
