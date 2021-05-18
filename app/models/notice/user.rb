module Notice
  class User < ApplicationRecord
    self.table_name = 'users'
    include Model::User
  end
end
