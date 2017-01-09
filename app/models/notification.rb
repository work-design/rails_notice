class Notification < ApplicationRecord
  default_scope -> { order(id: :desc) }
  scope :unread, -> { where(read_at: nil) }
  scope :have_read, -> { where.not(read_at: nil) }

  after_create_commit :process_job, :update_unread_count

  def process_job
    if sending_at
      NotificationJob.set(wait_until: sending_at).perform_later id
    else
      NotificationJob.perform_later(self.id)
    end
  end

  def unread_count
    Rails.cache.read("receiver_#{self.receiver_id}_unread") || 0
  end

  def update_unread
    if read_at.blank?
      update(read_at: Time.now)
      Rails.cache.decrement "receiver_#{self.receiver_id}_unread"
    end
  end

  def update_unread_count
    Rails.cache.write "receiver_#{self.receiver_id}_unread", Notification.where(receiver_id: self.receiver_id, read_at: nil).count, raw: true
  end

  def self.update_unread_count(receiver_id)
    Rails.cache.write "receiver_#{receiver_id}_unread", Notification.where(receiver_id: user_id, read_at: nil).count, raw: true
  end

end
