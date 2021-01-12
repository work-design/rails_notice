class UserTagged < ApplicationRecord
  include AuthModel::UserTagged
  include RailsNotice::UserTagged
end
