module RailsNotice::UserTagged
  extend ActiveSupport::Concern
  included do
    has_many :annunciates, foreign_key: :user_tag_id, primary_key: :user_tag_id
  end
  
end
