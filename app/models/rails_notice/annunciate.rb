module RailsNotice::Annunciate
  extend ActiveSupport::Concern
  included do
    attribute :receiver_type, :string, default: 'User'
    
    belongs_to :annunciation
    belongs_to :user_tag, optional: true
  end
  
  def to_notification
    self.update(state: 'published')
    Notification.bulk_insert_from_model(
      receiver_type.constantize,
      filter: { organ_id: annunciation.organ_id, 'user_taggeds.user_tag_id': user_tag_id },
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
    apps = WechatPublic.valid.where(organ_id: annunciation.organ_id)
    apps.map do |app|
      tag_ids = app.wechat_tags.where(user_tag_id: user_tag_id).pluck(:tag_id)
      app.api.message_mass_sendall(body, tag_ids)
    end
  end
  
end
