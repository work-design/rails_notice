class UserTagged < ApplicationRecord
  include RailsAuth::UserTagged
  include RailsNotice::UserTagged
end unless defined? UserTagged
