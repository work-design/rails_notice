module RailsNotice::Annunciation
  extend ActiveSupport::Concern
  included do
    class_attribute :notifies, default: {}
    attribute :state, :string, default: 'init'
    attribute :link, :string

    belongs_to :publisher, polymorphic: true
    has_many :notifications, as: :notifiable
    has_many :annunciates, dependent: :nullify
    has_many :user_tags, through: :annunciates
  
    acts_as_notify :default,
                   only: [:title, :body, :link]
  
    enum state: {
      init: 'init',
      published: 'published'
    }
  end
  
  def to_wechat
    apps = WechatPublic.valid.where(organ_id: self.organ_id)
    apps.map do |app|
      open_ids = WechatUser.where(app_id: app.appid).limit(10000).pluck(:uid)
      app.api.message_mass_sendall(body)
    end
  end


end
