module RailsNotice::Notification
  extend ActiveSupport::Concern
  included do
    attribute :code, :string, default: 'default'
    attribute :organ_id, :integer
    attribute :official, :boolean, default: false
    attribute :archived, :boolean, default: false
    
    belongs_to :receiver, polymorphic: true
    belongs_to :sender, polymorphic: true, optional: true
    belongs_to :notifiable, polymorphic: true, optional: true
    belongs_to :linked, polymorphic: true, optional: true
    has_one :notification_setting, ->(o) { where(receiver_type: o.receiver_type) }, primary_key: :receiver_id, foreign_key: :receiver_id
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
      r.counters = receiver.compute_unread_count
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
    send_to_socket
  end

  def send_to_email
    return unless email_enable?

    if notify_setting[:mailer_class]
      notify_method = notify_setting[:mailer_method] || 'notify'
      if sending_at
        notify_setting[:mailer_class].public_send(notify_method, self.notifiable_id).deliver_later(wait_until: sending_at)
      else
        notify_setting[:mailer_class].public_send(notify_method, self.notifiable_id).deliver_later
      end
    else
      if sending_at
        RailsNoticeMailer.notify(self.id).deliver_later(wait_until: sending_at)
      else
        RailsNoticeMailer.notify(self.id).deliver_later
      end
    end
  end

  def send_to_socket
    return unless receiver
    receiver.authorized_tokens.each do |authorized_token|
      ActionCable.server.broadcast(
        authorized_token.token,
        id: id,
        body: body,
        count: unread_count,
        link: link,
        showtime: notification_setting.showtime
      )
      self.notification_sendings.find_or_create_by(way: 'websocket', sent_to: authorized_token.token)
    end
  end

  def email_enable?
    if receiver.notification_setting.accept_email
      return true
    end

    if receiver.notification_setting.accept_email.is_a?(FalseClass)
      return false
    end

    RailsNotice.config.default_send_email
  end

  def notifiable_detail
    r = self.notifiable.as_json(**notify_setting.slice(:only, :except, :include, :methods))
    Hash(r).with_indifferent_access
  end

  def linked_detail
    r = self.linked.as_json(**linked_setting.slice(:only, :except, :include, :methods))
    Hash(r).with_indifferent_access
  end

  def linked_setting
    nt = linked_type&.constantize
    if nt.respond_to?(:notifies)
      r = nt.notifies
      Hash(r[self.code])
    else
      {}
    end
  end

  def notifiable_attributes
    if verbose
      r = notifiable_detail
      r.transform_values! do |i|
        next i unless i.acts_like?(:time)
        if self.receiver.respond_to?(:timezone)
          time_zone = self.receiver.timezone
        else
          time_zone = Time.zone.name
        end
        i.in_time_zone(time_zone).strftime '%Y-%m-%d %H:%M:%S'
      end
      r
    else
      {}.with_indifferent_access
    end
  end

  def notify_setting
    nt = notifiable_type.constantize
    if nt.respond_to?(:notifies)
      r = nt.notifies
      Hash(r[self.code])
    else
      {}
    end
  end

  def tr_key(column)
    return unless notifiable
    "#{self.class.i18n_scope}.notify.#{notifiable.class.base_class.model_name.i18n_key}.#{self.code}.#{column}"
  end

  def tr_value(column)
    keys = I18nHelper.interpolate_key(I18n.t(tr_key(column)))
    notifiable_detail.slice *keys
  end

  def code
    super ? super.to_sym : :default
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

  def cc_emails
    r = notify_setting.fetch(:cc_emails, []).map do |i|
      next i unless i.respond_to?(:call)
      i.call(notifiable)
    end
    r.flatten
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
      self.unscoped.select(:notifiable_type).distinct.pluck(:notifiable_type).sort
    end
  end
end
