module RailsNotice::Notifiable
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
      return if other_params[:sender] == receiver  # do not send notification to himself
      n.sender_id = other_params[:sender].id
      n.sender_type = other_params[:sender].class
    else
      n.sender_id = RailsNotice.config.default_sender_id
      n.sender_type = RailsNotice.config.default_sender_type
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
  
  def wechat_config
    
  end

end
