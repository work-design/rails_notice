module Notice
  class UserTagged < ApplicationRecord
    self.table_name = 'auth_user_taggeds'
    include Model::UserTagged
  end
end
