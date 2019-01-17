class Annunciation < ApplicationRecord
  class_attribute :notifies, default: {}
  attribute :state, :string, default: 'init'

  belongs_to :publisher, polymorphic: true
  has_many :notifications, as: :notifiable

  enum state: {
    init: 'init',
    published: 'published'
  }

  def to_notifications
    self.update(state: 'published')
    Notification.bulk_insert_from_model(
      User,
      select: { receiver_id: 'id' },
      value: {
        receiver_type: 'User',
        sender_type: self.publisher_type,
        sender_id: self.publisher_id,
        notifiable_type: 'Annunciation',
        notifiable_id: self.id
      }
    )
  end


end
