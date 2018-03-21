module TheNotifiable
  extend ActiveSupport::Concern

  included do
    delegate :url_helpers, to: 'Rails.application.routes'

    Notification.belongs_to :publisher, class_name: name, foreign_key: 'publisher_id', optional: true, inverse_of: :notifications
    has_many :notifications, as: 'notifiable', dependent: :nullify
  end

end
