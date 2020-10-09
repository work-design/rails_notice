class UserAnnunciate < ApplicationRecord
  include RailsNotice::UserAnnunciate
end unless defined? UserAnnunciate
