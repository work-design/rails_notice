module RailsNoticeExt::Setting
  extend ActiveSupport::Concern

  included do
    if connection.adapter_name == 'PostgreSQL'
      attribute :notifiable_types, :string, array: true, default: []
    else
      serialize :notifiable_types, Array
    end
    attribute :counters, :json, default: {}
    attribute :showtime, :integer, default: 0
    attribute :accept_email, :boolean, default: true
  end

  def unread_count
    r = counters.fetch(:counters, {}).dig('total')
    r.to_i
  end

  def reset_unread_count
    update counters: compute_unread_count
  end

  class_methods do

    def increment_unread_counter(col, num = 1)
      s = "jsonb_set(counters, '{#{col}}', (COALESCE(counters->>'#{col}', '0')::int + #{num})::text::jsonb)"

      sql = "counters = #{s}"
      update_all sql
    end

    def decrement_unread_counter(col, num = 1)
      s = "jsonb_set(counters, '{#{col}}', (COALESCE(counters->>'#{col}', '0')::int - #{num})::text::jsonb)"

      sql = "counters = #{s}"
      update_all sql
    end

    def reset_counters
      self.find_each do |ns|
        ns.user.reset_unread_count if ns.user
      end
    end

  end

end
