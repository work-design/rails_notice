module RailsNotice::Member
  extend ActiveSupport::Concern

  included do
    has_many :notifications, dependent: :delete_all
    has_one :notification_setting, dependent: :delete

    has_many :member_annunciates, through: :member_departments
  end

  def unread_count
    r = notification_setting.counters.fetch(:counters, {}).dig('total')
    r.to_i
  end

  def apply_pending_annunciations
    annunciation_ids = pending_annunciation_ids
    return if annunciation_ids.blank?

    annunciation_ids.each_slice(50) do |ids|
      annunciations = Annunciation.where(id: ids)
      annunciation_attributes = annunciations.map do |annunciation|
        r = {}
        r.merge! annunciation.attributes.slice(:organ_id, :link)
        r.merge!(
          member_id: self.id,
          user_id: self.user_id,
          organ_id: self.organ_id,
          sender_type: annunciation.publisher_type,
          sender_id: annunciation.publisher_id,
          notifiable_type: annunciation.class.name,
          notifiable_id: annunciation.id,
          official: true,
          archived: false,
          created_at: annunciation.created_at
        )
        r
      end

      Annunciation.increment_counter(:notifications_count, ids)
      Notification.insert_all(annunciation_attributes)
    end
  end

  def notification_setting
    r = super || build_notification_setting
    if r.new_record?
      r.counters = compute_unread_count
      r.save
    end
    r
  end

  def pending_annunciation_ids
    all_annunciation_ids = member_annunciates.default_where('created_at-gte': self.created_at).order(annunciation_id: :desc).pluck(:annunciation_id).compact
    made_annunciation_ids = notifications.where(notifiable_type: 'MemberAnnunciation').pluck(:notifiable_id)

    all_annunciation_ids - made_annunciation_ids
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

    added_count = pending_annunciation_ids.size
    [:total, :official, :'Annunciation'].each do |counter|
      counters[counter] = counters[counter].to_i + added_count
    end

    counters
  end

  def reset_unread_count
    notification_setting.update counters: compute_unread_count
  end

end
