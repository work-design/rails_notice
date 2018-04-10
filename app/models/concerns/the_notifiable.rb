module TheNotifiable
  extend ActiveSupport::Concern

  included do
    delegate :url_helpers, to: 'Rails.application.routes'

    has_many :notifications, as: 'notifiable', dependent: :nullify
  end

end
