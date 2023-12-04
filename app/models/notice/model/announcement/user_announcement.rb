module Notice
  module Model::Announcement::UserAnnouncement
    extend ActiveSupport::Concern

    included do
      has_many :announcement_user_tags, dependent: :destroy_async
      has_many :user_tags, through: :annunciates
    end

  end
end
