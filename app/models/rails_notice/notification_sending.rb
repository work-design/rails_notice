module RailsNotice::NotificationSending
  extend ActiveSupport::Concern
  included do
    attribute :sent_at, :datetime, default: -> { Time.now }
    attribute :sent_result, :string
    attribute :way, :string
    
    belongs_to :notification
    
    enum way: {
      email: 'email',
      websocket: 'websocket'
    }
  end
  
end
