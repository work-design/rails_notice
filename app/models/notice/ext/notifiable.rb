module Notice
  module Ext::Notifiable
    extend ActiveSupport::Concern

    included do
      delegate :url_helpers, to: 'Rails.application.routes'

      has_many :notifications, class_name: 'Notice::Notification', as: :notifiable
    end

    def to_notification(user: nil, member: nil, **other_params)
      n = self.notifications.build
      n.member = member
      n.user = user || member&.user

      return unless n.user

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
        :title, :body, :link, :organ_id,
        :verbose, :code,
        :cc_emails,
        :linked_type, :linked_id
      )
      n.organ_id ||= self.organ_id if respond_to?(:organ_id)

      n.save!
      n
    end

  end
end

