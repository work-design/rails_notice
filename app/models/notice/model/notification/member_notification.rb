module Notice
  module Model::Notification::MemberNotification
    extend ActiveSupport::Concern

    included do
      belongs_to :member, class_name: 'Org::Member', foreign_key: :receiver_id
    end

    def wechat_users
      [member.wechat_user].presence || member.wechat_users.default_where(appid: organ.apps.where(type: ['Wechat::PublicApp', 'Wechat::PublicAgency']).pluck(:appid))
    end

    def increment_unread
      counters = ['total', notifiable_type]
      counters << 'official' if self.official
      counters.each do |counter|
        member.counters[counter] = member.counters[counter].to_i + 1
      end
      member.save
    end

    def decrement_unread
      counters = ['total', notifiable_type]
      counters << 'official' if self.official
      counters.each do |counter|
        member.counters[counter] = member.counters[counter].to_i - 1
      end
      member.save
    end

    def reset_unread_count
      member.reset_unread_count
    end

  end
end
