module RailsNotice::NotificationSetting
  extend ActiveSupport::Concern
  included do
    belongs_to :receiver, polymorphic: true
    if connection.adapter_name == 'PostgreSQL'
      attribute :notifiable_types, :string, array: true, default: -> { RailsNotice.config.default_notifiable_types }
    else
      serialize :notifiable_types, Array
    end
    attribute :counters, :json, default: {}
    attribute :showtime, :integer, default: 0
    attribute :accept_email, :boolean, default: RailsNotice.config.default_send_email
  end

  class_methods do
    def reset_counters
      self.find_each do |ns|
        ns.receiver.reset_unread_count if ns.receiver
      end
    end
  end

end
