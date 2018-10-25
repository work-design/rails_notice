module RailsNoticeNotifiable
  extend ActiveSupport::Concern

  included do
    class_attribute :notifies, default: {}
    delegate :url_helpers, to: 'Rails.application.routes'

    has_many :notifications, as: 'notifiable', dependent: :delete_all

    RailsNotice.notifiable_types << self.name unless RailsNotice.notifiable_types.include?(self.name)
  end

  def to_notification(receiver: , **other_params)
    n = self.notifications.build
    n.receiver_id = receiver.id
    n.receiver_type = receiver.class

    if other_params[:sender]
      n.sender_id = other_params[:sender].id
      n.sender_type = other_params[:sender].class
    end

    n.assign_attributes other_params.slice(
      :title, :body, :link,
      :verbose, :code,
      :cc_emails
    )

    n.save!
  end

end
