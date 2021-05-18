module Notice
  class Member < ApplicationRecord
    self.table_name = 'org_members'
    include Model::Member
  end
end
