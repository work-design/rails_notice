module Notice
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      has_many :notifications, class_name: 'Notice::Notification', dependent: :delete_all
      has_many :announcement_departments, class_name: 'Notice::AnnouncementDepartment', through: :member_departments
      has_many :announcement_job_titles, class_name: 'Notice::AnnouncementJobTitle', through: :member_departments, source: :job_title
      has_many :announcement_organs, class_name: 'Notice::AnnouncementOrgan', primary_key: :organ_id, foreign_key: :organ_id
    end

    def apply_pending_annunciations
      announcement_ids = pending_announcement_ids
      return if announcement_ids.blank?

      announcement_ids.each_slice(50) do |ids|
        annunciations = Announcement.where(id: ids)
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
            created_at: annunciation.created_at,
            updated_at: Time.current
          )
          r
        end

        Annunciation.increment_counter(:notifications_count, ids)
        Notification.insert_all(annunciation_attributes)
      end
    end

    def pending_announcement_ids
      organ_ids = announcement_organs.default_where('created_at-gte': self.created_at).pluck(:announcement_id)
      department_ids = announcement_departments.default_where('created_at-gte': self.created_at).pluck(:announcement_id)
      job_title_ids = announcement_job_titles.default_where('created_at-gte': self.created_at).pluck(:announcement_id)
      all_ids = (organ_ids + department_ids + job_title_ids).uniq
      made_ids = notifications.where(notifiable_type: 'Notice::MemberAnnouncement').pluck(:notifiable_id)

      all_ids - made_ids
    end

    def compute_unread_count
      no = notifications.where(archived: false, read_at: nil)
      _counters = {
        'total' => no.count,
        'official' => no.where(official: true).count
      }

      Notification.notifiable_types.map do |nt|
        _counters.merge! nt.to_sym => no.where(notifiable_type: nt).count
      end

      added_count = pending_announcement_ids.size
      ['total', 'official', 'Notice::MemberAnnouncement'].each do |counter|
        _counters[counter] = _counters[counter].to_i + added_count
      end

      self.counters = _counters
    end

    def unread_count
      counters['total'] || 0
    end

  end
end
