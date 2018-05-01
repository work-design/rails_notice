class Annunciation < ApplicationRecord
  belongs_to :publisher, polymorphic: true
  serialize :notifiable_types, Array


  def notifiable_types
    super + TheNotify.config.default_notifiable_types
  end
end
