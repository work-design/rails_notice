module RailsNotice::MemberDepartment
  extend ActiveSupport::Concern

  included do
    has_many :member_annunciates, foreign_key: :department_id, primary_key: :department_id
  end

end
