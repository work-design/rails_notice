module RailsNotice::Notifiable
  extend ActiveSupport::Concern

  included do
    delegate :url_helpers, to: 'Rails.application.routes'

    has_many :notifications, as: :notifiable
  end

  def to_notification(receiver: , **other_params)
    n = self.notifications.build
    n.organ_id = self.organ_id if respond_to?(:organ_id)
    n.receiver_id = receiver.id
    n.receiver_type = receiver.class

    if other_params[:sender]
      return if other_params[:sender] == receiver  # do not send notification to himself
      n.sender_id = other_params[:sender].id
      n.sender_type = other_params[:sender].class
    end

    if other_params[:linked]
      n.linked_type = other_params[:linked].class.name
      n.linked_id = other_params[:linked].id
    end

    n.assign_attributes other_params.slice(
      :title, :body, :link,
      :verbose, :code,
      :cc_emails,
      :linked_type, :linked_id
    )

    n.save!
  end

end
