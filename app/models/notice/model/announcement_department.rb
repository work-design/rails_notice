module Notice
  module Model::AnnouncementDepartment
    extend ActiveSupport::Concern
    include Inner::Announce

    included do
      belongs_to :department, class_name: 'Org::Department'


      has_many :members, through: :member_departments

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
