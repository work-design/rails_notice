class Notification < ApplicationRecord
  belongs_to :receiver, polymorphic: true
  has_one :notification_setting, ->(o) { where(receiver_type: o.receiver_type) }, primary_key: :receiver_id, foreign_key: :receiver_id

  default_scope -> { order(id: :desc) }
  scope :unread, -> { where(read_at: nil) }
  scope :have_read, -> { where.not(read_at: nil) }

  after_create_commit :process_job, :update_unread_count

  def process_job
    if sending_at
      NotificationJob.set(wait_until: sending_at).perform_later id
    else
      # debug
      #NotificationJob.perform_later(self.id)
      s = NotificationJob.set(wait: 10.seconds).perform_later id
      self.update job_id: s.job_id
    end
  end

  def unread_count
    Rails.cache.read("#{receiver_type}_#{self.receiver_id}_unread") || 0
  end

  def update_unread
    if read_at.blank?
      update(read_at: Time.now)
      Rails.cache.decrement "#{receiver_type}_#{self.receiver_id}_unread"
    end
  end

  def update_unread_count
    Rails.cache.write "#{receiver_type}_#{self.receiver_id}_unread", Notification.where(receiver_id: self.receiver_id, receiver_type: self.receiver_type, read_at: nil).count, raw: true
  end

  def self.update_unread_count(receiver)
    Rails.cache.write "#{receiver.class.name}_#{receiver.id}_unread", Notification.where(receiver_id: receiver.id, receiver_type: receiver.class.name, read_at: nil).count, raw: true
  end

end

# notifiable_type:
# notifiable_id: