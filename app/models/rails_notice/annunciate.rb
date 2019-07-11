module RailsNotice::Annunciate
  extend ActiveSupport::Concern
  included do
    belongs_to :annunciation
    belongs_to :tag
  end
  
end
