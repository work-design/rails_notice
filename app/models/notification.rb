class Notification < ApplicationRecord
  belongs_to :receiver, polymorphic: true
  belongs_to :notifiable, polymorphic: true, optional: true
  has_one :notification_setting, ->(o) { where(receiver_type: o.receiver_type) }, primary_key: :receiver_id, foreign_key: :receiver_id

  default_scope -> { order(id: :desc) }
  scope :unread, -> { where(read_at: nil) }
  scope :have_read, -> { where.not(read_at: nil) }

  after_create_commit :process_job, :update_unread_count

  def process_job
    make_as_unread
    if sending_at
      NotificationJob.set(wait_until: sending_at).perform_later id
      TheNotifyMailer.notify(self.id).deliver_later(wait_until: sending_at)
    else
      NotificationJob.perform_later(self.id)
      TheNotifyMailer.notify(self.id).deliver_later
    end
  end

  def send_email
    TheNotifyMailer.notify(self.id).deliver_later
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