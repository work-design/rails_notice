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

  def to_notification(receiver_type: 'User')
    self.update(state: 'published')
    Notification.bulk_insert_from_model(
      receiver_type.constantize,
      filter: { organ_id: self.organ_id },
      select: { receiver_id: 'id' },
      value: {
        link: self.link,
        receiver_type: receiver_type,
        sender_type: self.publisher_type,
        sender_id: self.publisher_id,
        notifiable_type: self.class.name,
        notifiable_id: self.id,
        official: true
      }
    )
  end
  
  def to_wechat
    apps = WechatPublic.where(organ_id: self.organ_id)
    apps.map do |app|
      open_ids = WechatUser.where(app_id: app.appid).limit(10000).pluck(:uid)
      app.api.message_mass_sendall(body)
    end
  end


end
