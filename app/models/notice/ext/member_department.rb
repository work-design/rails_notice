module Notice
  module Ext::MemberDepartment
    extend ActiveSupport::Concern

    included do
      has_many :announcement_departments, class_name: 'Notice::AnnouncementDepartment', primary_key: :department_id, foreign_key: :department_id
    end

  end
end
