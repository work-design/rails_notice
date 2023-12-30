module Notice
  module Model::Notification::UserNotification
    extend ActiveSupport::Concern

    included do
      belongs_to :user, class_name: 'Auth::User', optional: true
    end

  end
end
