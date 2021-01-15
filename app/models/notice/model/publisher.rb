module Notice
  module Model::Publisher
    extend ActiveSupport::Concern

    included do
      has_many :published_notifications, class_name: 'Notification', foreign_key: 'publisher_id', dependent: :nullify
    end

  end
end
