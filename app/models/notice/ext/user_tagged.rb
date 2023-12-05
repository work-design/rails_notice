module Notice
  module Ext::UserTagged
    extend ActiveSupport::Concern

    included do
      has_many :announcement_user_tags, class_name: 'Notice::AnnouncementUserTag', primary_key: :user_tag_id, foreign_key: :user_tag_id
    end

  end
end
