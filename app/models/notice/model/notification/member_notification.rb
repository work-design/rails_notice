module Notice
  module Model::Notification::MemberNotification
    extend ActiveSupport::Concern

    included do
      belongs_to :member, class_name: 'Org::Member', optional: true
    end

  end
end
