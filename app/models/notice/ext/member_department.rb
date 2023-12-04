module Notice
  module Ext::MemberDepartment
    extend ActiveSupport::Concern

    included do
      has_many :annunciate_departments, class: 'M', foreign_key: :department_id, primary_key: :department_id
    end

  end
end
