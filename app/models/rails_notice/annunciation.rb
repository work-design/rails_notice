module RailsNotice::Annunciation
  extend ActiveSupport::Concern
  included do
    class_attribute :notifies, default: {}
    attribute :title, :string
    attribute :body, :string
    attribute :link, :string

    belongs_to :publisher, polymorphic: true, optional: true
    has_many :notifications, as: :notifiable
    has_many :annunciates, dependent: :nullify
    has_many :user_tags, through: :annunciates
    
    has_one_attached :cover
    acts_as_notify :default, only: [:title, :body, :link], methods: [:cover_url]
  end
  
  def cover_url
    cover.service_url if cover.present?
  end
  
end
