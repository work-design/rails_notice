module RailsNotice::Annunciate
  extend ActiveSupport::Concern
  included do
    attribute :receiver_type, :string, default: 'User'
    
    belongs_to :annunciation
    belongs_to :user_tag, optional: true
  end
  
  
  
end
