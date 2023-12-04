module Notice
  module Model::Announcement::MemberAnnouncement
    extend ActiveSupport::Concern

    included do
      has_many :announcement_departments, class_name: 'AnnouncementDepartment', foreign_key: :annunciation_id, dependent: :destroy_async
      has_many :departments, class_name: 'Org::Department', through: :annunciates
      has_many :job_titles, class_name: 'Org::JobTitle', through: :annunciates
    end

  end
end
