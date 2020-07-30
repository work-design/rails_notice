module RailsNotice::UserTagged
  extend ActiveSupport::Concern

  included do
    has_many :annunciates, foreign_key: :user_tag_id, primary_key: :user_tag_id
    has_many :notification_settings, -> { where(receiver_type: 'User') }, foreign_key: :receiver_id, primary_key: :user_id
  end

end
