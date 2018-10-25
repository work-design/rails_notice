class Annunciation < ApplicationRecord
  belongs_to :publisher, polymorphic: true

end
