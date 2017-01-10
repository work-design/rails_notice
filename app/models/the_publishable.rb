module ThePublishable

  included do
    Notification.belongs_to :publisher, class_name: name, foreign_key: 'publisher_id', optional: true, inverse_of: :notifications
    has_many :notifications, dependent: :destroy
  end

end
