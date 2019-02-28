class NotificationSetting < ApplicationRecord
  belongs_to :receiver, polymorphic: true
  serialize :notifiable_types, Array
  attribute :counters, :json, default: {}
  attribute :showtime, :integer, default: 0
  attribute :accept_email, :boolean, default: RailsNotice.config.default_send_email



  def notifiable_types
    super + RailsNotice.config.default_notifiable_types
  end

  def increment_counter(col, num = 1)
    s = "jsonb_set(counters, '{#{col}}', (COALESCE(counters->>'#{col}', '0')::int + #{num})::text::jsonb)"

    sql = "UPDATE #{self.class.table_name} SET counters = #{s} WHERE id = #{self.id}"
    self.class.connection.execute sql
  end

  def decrement_counter(col, num = 1)
    s = "jsonb_set(counters, '{#{col}}', (COALESCE(counters->>'#{col}', '0')::int - #{num})::text::jsonb)"

    sql = "UPDATE #{self.class.table_name} SET counters = #{s} WHERE id = #{self.id}"
    self.class.connection.execute sql
  end

  def self.reset_counters
    self.find_each do |ns|
      Notification.reset_unread_count(ns.receiver)
    end
  end

end
