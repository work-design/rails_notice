module Notice
  module Ext::UserTagged
    extend ActiveSupport::Concern

    included do
      has_many :annunciates, foreign_key: :user_tag_id, primary_key: :user_tag_id
      has_many :notification_settings, foreign_key: :user_id, primary_key: :user_id
    end

  end
end
