class Notification < ApplicationRecord
  serialize :cc_emails, Array

  attribute :code, :string, default: 'default'
  belongs_to :receiver, polymorphic: true
  belongs_to :notifiable, polymorphic: true, optional: true
  has_one :notification_setting, ->(o) { where(receiver_type: o.receiver_type) }, primary_key: :receiver_id, foreign_key: :receiver_id

  default_scope -> { order(id: :desc) }
  scope :unread, -> { where(read_at: nil) }
  scope :have_read, -> { where.not(read_at: nil) }

  after_create_commit :process_job,
                      :send_email,
                      :update_unread_count

  def process_job
    make_as_unread
    if sending_at
      NotificationJob.set(wait_until: sending_at).perform_later id
    else
      NotificationJob.perform_later(self.id)
    end
  end

  def send_email
    return unless email_enable?

    if notify_setting[:mailer_class]
      notify_method = notify_setting[:mailer_method] || 'notify'
      if sending_at
        notify_setting[:mailer_class].public_send(notify_method, self.notifiable_id).deliver_later(wait_until: sending_at)
      else
        notify_setting[:mailer_class].public_send(notify_method, self.notifiable_id).deliver_later
      end
    end

    if sending_at
      TheNotifyMailer.notify(self.id).deliver_later(wait_until: sending_at)
    else
      TheNotifyMailer.notify(self.id).deliver_later
    end
  end

  def email_enable?
    if receiver.notification_setting&.accept_email
      return true
    end

    if receiver.notification_setting&.accept_email.is_a?(FalseClass)
      return false
    end

    TheNotify.config.default_send_email
  end

  def notifiable_detail
    r = self.notifiable.as_json(**notify_setting.slice(:only, :except, :include, :methods))
    r.with_indifferent_access
  end

  def notifiable_attributes
    if verbose
      r = notifiable_detail
      r.transform_values! do |i|
        next i unless i.acts_like?(:time)
        if self.receiver.respond_to?(:timezone)
          _zone = self.receiver.timezone
        else
          _zone = Time.zone.name
        end
        i.in_time_zone(_zone).strftime '%Y-%m-%d %H:%M:%S'
      end
      r
    else
      {}.with_indifferent_access
    end
  end

  def notify_setting
    notifiable_type.constantize.notifies[self.code] || {}
  end

  def tr_key(column)
    "#{self.class.i18n_scope}.notify.#{notifiable.class.base_class.model_name.i18n_key}.#{self.code}.#{column}"
  end

  def code
    super ? super.to_sym : :default
  end

  def title
    tr_values = notifiable_detail.slice *I18nHelper.interpolate_key(I18n.t(tr_key(:title)))
    tr_values.merge! notify_setting.fetch(:tr_values, {})

    if super.blank?
      I18n.t tr_key(:title), tr_values
    else
      super
    end
  end

  def body
    tr_values = notifiable_detail.slice *I18nHelper.interpolate_key(I18n.t(tr_key(:body)))
    tr_values.merge! notify_setting.fetch(:tr_values, {})

    if super.blank?
      I18n.t tr_key(:body), tr_values
    else
      super
    end
  end

  def cc_emails
    r = notify_setting.fetch(:cc_emails, []).map do |i|
      next i unless i.respond_to?(:call)
      i.call(notifiable)
    end
    r.concat super
  end

  def unread_count
    Rails.cache.read("#{self.receiver_type}_#{self.receiver_id}_unread") || 0
  end

  def make_as_unread
    if read_at.present?
      self.update(read_at: nil)
      Rails.cache.increment "#{self.receiver_type}_#{self.receiver_id}_unread"
    end
  end

  def make_as_read
    if read_at.blank?
      update(read_at: Time.now)
      Rails.cache.decrement "#{self.receiver_type}_#{self.receiver_id}_unread"
    end
  end

  def update_unread_count
    Rails.cache.write "#{self.receiver_type}_#{self.receiver_id}_unread", Notification.where(receiver_id: self.receiver_id, receiver_type: self.receiver_type, read_at: nil).count, raw: true
  end

  def self.update_unread_count(receiver)
    if Rails.cache.write "#{receiver.class.name}_#{receiver.id}_unread", Notification.where(receiver_id: receiver.id, receiver_type: receiver.class.name, read_at: nil).count, raw: true
      Rails.cache.read "#{receiver.class.name}_#{receiver.id}_unread"
    end
  end

end

# notifiable_type:
# notifiable_id: