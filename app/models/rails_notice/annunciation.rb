module RailsNotice::Annunciation
  extend ActiveSupport::Concern
  included do
    class_attribute :notifies, default: {}
    attribute :link, :string

    belongs_to :publisher, polymorphic: true
    has_many :notifications, as: :notifiable
    has_many :annunciates, dependent: :nullify
    has_many :user_tags, through: :annunciates
  
    acts_as_notify :default, only: [:title, :body, :link]
  end
  
end
