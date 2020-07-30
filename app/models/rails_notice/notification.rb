module RailsNotice::Notification
  extend ActiveSupport::Concern

  included do
    attribute :state, :string
    attribute :title, :string
    attribute :body, :string, limit: 5000
    attribute :link, :string
    attribute :sending_at, :datetime
    attribute :read_at, :datetime, index: true
    attribute :code, :string, default: 'default'
    attribute :official, :boolean, default: false
    attribute :archived, :boolean, default: false
    attribute :verbose, :boolean, default: false
    attribute :created_at, :datetime, null: false, index: true

    belongs_to :user
    belongs_to :organ, optional: true
    belongs_to :sender, polymorphic: true, optional: true
    belongs_to :notifiable, polymorphic: true, optional: true
    belongs_to :linked, polymorphic: true, optional: true
    has_one :notification_setting, primary_key: :user_id, foreign_key: :user_id
    has_many :notification_sendings, dependent: :delete_all

    default_scope -> { order(created_at: :desc) }
    scope :unread, -> { where(read_at: nil, archived: false) }
    scope :readed, -> { where.not(read_at: nil, archived: false) }

    after_create_commit :process_job
    after_create_commit :increment_unread, if: -> { read_at.blank? }
    after_destroy_commit :decrement_unread, if: -> { read_at.blank? }
  end

  def notification_setting
    r = super || build_notification_setting
    if r.new_record?
      r.counters = user.compute_unread_count
      r.save
    end
    r
  end

  def process_job
    if sending_at
      NotificationJob.set(wait_until: sending_at).perform_later(self)
    else
      NotificationJob.perform_later(self)
    end
  end

  def send_out

  end

  def notifiable_detail
    r = self.notifiable.as_json(**notify_setting.slice(:only, :except, :include, :methods))
    Hash(r)
  end

  def linked_detail
    r = self.linked.as_json(**linked_setting.slice(:only, :except, :include, :methods))
    Hash(r)
  end

  def linked_setting
    RailsNotice.notifiable_types.dig(linked_type, self.code.to_sym) || {}
  end

  def notifiable_attributes
    if verbose
      r = notifiable_detail
      r.transform_values! do |i|
        next i unless i.acts_like?(:time)
        if self.user.respond_to?(:timezone)
          time_zone = self.user.timezone
        else
          time_zone = Time.zone.name
        end
        i.in_time_zone(time_zone).strftime '%Y-%m-%d %H:%M:%S'
      end
      r
    else
      {}
    end
  end

  def notify_setting
    RailsNotice.notifiable_types.dig(notifiable_type, self.code.to_sym) || {}
  end

  def tr_key(column)
    return unless notifiable
    "#{self.class.i18n_scope}.notify.#{notifiable.class.base_class.model_name.i18n_key}.#{self.code}.#{column}"
  end

  def tr_value(column)
    keys = RailsNotice::I18nHelper.interpolate_key(I18n.t(tr_key(column)))
    notifiable_detail.with_indifferent_access.slice *keys
  end

  def title
    return super if super.present?

    if I18n.exists? tr_key(:title)
      tr_values = tr_value(:title)
      tr_values.merge! notify_setting.fetch(:tr_values, {})
      return I18n.t tr_key(:title), tr_values.symbolize_keys
    end

    if notifiable.respond_to?(:title)
      notifiable.title
    end
  end

  def body
    return super if super.present?

    if I18n.exists? tr_key(:body)
      tr_values = tr_value(:body)
      tr_values.merge! notify_setting.fetch(:tr_values, {})
      return I18n.t tr_key(:body), tr_values.symbolize_keys
    end

    if notifiable.respond_to?(:body)
      notifiable.body
    end
  end

  def unread_count
    notification_setting.counters.fetch(:counters, {}).dig('total')
  end

  def make_as_read
    return unless self.read_at.blank?
    self.read_at = Time.current
    notifiable.readed_count += 1 if notifiable.class.attribute_method?(:readed_count)
    self.class.transaction do
      decrement_unread if just_readed?
      notifiable.save!
      save!
    end
  end

  def make_as_unread
    return if self.read_at.blank?
    self.read_at = nil
    self.class.transaction do
      increment_unread if read_at_changed?
      save!
    end
  end

  def increment_unread
    counters = ['total', notifiable_type]
    counters << 'official' if self.official
    counters.each do |counter|
      notification_setting.counters[counter] = notification_setting.counters[counter].to_i + 1
    end

    notification_setting.save
  end

  def decrement_unread
    counters = ['total', notifiable_type]
    counters << 'official' if self.official
    counters.each do |counter|
      notification_setting.counters[counter] = notification_setting.counters[counter].to_i - 1
    end

    notification_setting.save
  end

  def reset_unread_count
    self.receiver.reset_unread_count
  end

  def link
    if super.present?
      super
    elsif linked_type && linked_id
      url = URI(RailsNotice.config.link_host)
      url.path = "/#{linked_type.underscore}/#{linked_id}"
      url.to_s
    else
      url = URI(RailsNotice.config.link_host)
      url.path = "/#{self.class.name.underscore}/#{self.id}"
      url.to_s
    end
  end

  def just_readed?
    read_at_changed? && read_at_change[0].nil? && read_at_change[1].acts_like?(:time)
  end

  def saved_readed?
    saved_change_to_read_at && saved_change_to_read_at[0].nil? && saved_change_to_read_at[1].acts_like?(:time)
  end

  def archive
    self.read_at ||= Time.current
    self.archived = true
    self.class.transaction do
      decrement_unread if just_readed?
      save!
    end
  end

  class_methods do
    def notifiable_types
      self.unscoped.select(:notifiable_type).distinct.pluck(:notifiable_type).compact.sort!
    end
  end
end
