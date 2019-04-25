module RailsNotice::Annunciation
  extend ActiveSupport::Concern
  included do
    class_attribute :notifies, default: {}
    attribute :state, :string, default: 'init'
    attribute :link, :string
  
    belongs_to :publisher, polymorphic: true
    has_many :notifications, as: :notifiable
  
    acts_as_notify :default,
                   only: [:title, :body, :link]
  
    enum state: {
      init: 'init',
      published: 'published'
    }
  end

  def to_notifications
    self.update(state: 'published')
    Notification.bulk_insert_from_model(
      User,
      select: { receiver_id: 'id' },
      value: {
        link: self.link,
        receiver_type: 'User',
        sender_type: self.publisher_type,
        sender_id: self.publisher_id,
        notifiable_type: 'Annunciation',
        notifiable_id: self.id,
        official: true
      }
    )
  end


end
