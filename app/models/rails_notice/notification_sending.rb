module RailsNotice::NotificationSending
  extend ActiveSupport::Concern

  included do
    attribute :way, :string
    attribute :sent_to, :string
    attribute :sent_at, :datetime, default: -> { Time.current }
    attribute :sent_result, :string

    belongs_to :notification

    enum way: {
      email: 'email',
      websocket: 'websocket',
      wechat: 'wechat'
    }
  end

end
