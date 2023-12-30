module Notice
  module Ext::MemberNotifiable
    extend ActiveSupport::Concern

    included do
      has_many :notifications, class_name: 'Notice::MemberNotification', as: :notifiable
    end

    def to_member_notice(member:, **other_params)
      n = self.notifications.build
      n.member = member
      n.organ_id = member.organ_id
      n.store_other_params(other_params)
      n.save!
      n
    end

  end
end

