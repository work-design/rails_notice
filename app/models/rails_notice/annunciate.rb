module RailsNotice::Annunciate
  extend ActiveSupport::Concern
  included do
    attribute :receiver_type, :string, default: 'User'
    attribute :notifications_count, :integer, default: 0
    
    belongs_to :annunciation
    belongs_to :user_tag, optional: true
    has_many :user_taggeds, foreign_key: :user_tag_id, primary_key: :user_tag_id
    has_many :notification_settings, through: :user_taggeds
    
    after_create_commit :increment_unread_count
    after_destroy_commit :decrement_unread_count
  end
  
  def increment_unread_count
    ['total', 'official', 'Annunciation'].each do |col|
      notification_settings.increment_unread_counter(col)
    end
  end
  
  def decrement_unread_count
    ['total', 'official', 'Annunciation'].each do |col|
      notification_settings.decrement_unread_counter(col)
    end
  end
  
end
