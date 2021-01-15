module RailsNotice::Annunciation::UserAnnunciation
  extend ActiveSupport::Concern

  included do
    has_many :annunciates, class_name: 'UserAnnunciate', foreign_key: :annunciation_id, dependent: :destroy
    has_many :user_tags, through: :annunciates
  end

end
