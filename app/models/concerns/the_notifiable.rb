module TheNotifiable
  extend ActiveSupport::Concern

  included do
    delegate :url_helpers, to: 'Rails.application.routes'

    has_many :notifications, as: 'notifiable', dependent: :nullify

    TheNotify.notifiable_types << self.name unless TheNotify.notifiable_types.include?(self.name)
  end

  def to_notification(receiver: , **other_params)
    n = self.notifications.build
    n.receiver_id = receiver.id
    n.receiver_type = receiver.class

    n.assign_attributes other_params.slice(
      :title, :body, :link,
      :verbose, :code,
      :cc_emails
    )

    n.save!
  end

end
