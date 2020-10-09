module RailsNotice::Annunciation::UserAnnunciation
  extend ActiveSupport::Concern

  included do
    has_many :user_annunciates, dependent: :destroy
    has_many :user_tags, through: :user_annunciates
  end

end
