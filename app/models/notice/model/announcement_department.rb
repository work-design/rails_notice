module Notice
  module Model::AnnouncementDepartment
    extend ActiveSupport::Concern

    included do
      attribute :notifications_count, :integer, default: 0
      attribute :state, :string
      attribute :announce_at, :datetime

      belongs_to :department, class_name: 'Org::Department', optional: true
      belongs_to :announcement

      has_many :notification_settings, through: :user_taggeds
      has_many :same_annunciates, class_name: self.name, foreign_key: :annunciation_id, primary_key: :annunciation_id

      #after_create :increment_unread_count
      #after_destroy :decrement_unread_count
    end

    def increment_unread_count
      user_ids = same_user_ids

      ['total', 'official', 'Annunciation'].each do |col|
        notification_settings.where.not(user_id: user_ids).increment_unread_counter(col)
      end
    end

    def decrement_unread_count
      user_ids = same_user_ids

      ['total', 'official', 'Annunciation'].each do |col|
        notification_settings.where.not(user_id: user_ids).decrement_unread_counter(col)
      end
    end

    # todo better sql
    # 如果一个user 属于多个标签，则进行去重处理
    def same_user_ids
      user_tag_ids = self.same_annunciates.pluck(:user_tag_id)
      UserTagged.where(user_tag_id: user_tag_ids).having('COUNT(user_id) > 1').group(:user_id).count(:user_id).keys
    end

  end
end
