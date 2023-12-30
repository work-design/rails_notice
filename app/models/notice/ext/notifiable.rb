module Notice
  module Ext::Notifiable
    extend ActiveSupport::Concern

    included do
      has_many :notifications, class_name: 'Notice::UserNotification', as: :notifiable
    end

    def to_notification(user:, **other_params)
      n = self.notifications.build
      n.user = user
      n.store_other_params(other_params)
      n.organ_id ||= self.organ_id if respond_to?(:organ_id)
      n.save!
      n
    end

  end
end

