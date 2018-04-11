module TheNotifiable
  extend ActiveSupport::Concern

  included do
    delegate :url_helpers, to: 'Rails.application.routes'

    has_many :notifications, as: 'notifiable', dependent: :nullify

    TheNotify.notifiable_types << self.name unless TheNotify.notifiable_types.include?(self.name)
  end

end
