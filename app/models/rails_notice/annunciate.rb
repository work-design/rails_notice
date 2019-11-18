module RailsNotice::Annunciate
  extend ActiveSupport::Concern
  included do
    attribute :receiver_type, :string, default: 'User'
    attribute :notifications_count, :integer, default: 0
    
    belongs_to :annunciation
    belongs_to :user_tag, optional: true
    has_many :user_taggeds, foreign_key: :user_tag_id, primary_key: :user_tag_id
    
    after_create_commit :update_unread_count
  end
  
  def increment_unread_count
    users
  end
  
end
