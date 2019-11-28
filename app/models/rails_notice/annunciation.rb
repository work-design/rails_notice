module RailsNotice::Annunciation
  extend ActiveSupport::Concern
  included do
    class_attribute :notifies, default: {}
    
    attribute :title, :string
    attribute :body, :string
    attribute :link, :string
    attribute :notifications_count, :integer, default: 0
    attribute :readed_count, :integer, default: 0
    
    belongs_to :organ, optional: true
    belongs_to :publisher, polymorphic: true, optional: true
    has_many :notifications, as: :notifiable
    has_many :annunciates, dependent: :destroy
    has_many :user_tags, through: :annunciates
    
    has_one_attached :cover
    acts_as_notify :default, only: [:title, :body, :link], methods: [:cover_url]
  end
  
  def cover_url
    cover.service_url if cover.present?
  end
  
  def reset_counter
    self.notifications_count = self.notifications.count
    self.readed_count = self.notifications.readed.count
    self.save
  end
  
end
