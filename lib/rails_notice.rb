require 'rails_notice/engine'
require 'rails_notice/config'
require 'rails_notice/active_record'

module RailsNotice
  mattr_writer :notifiable_types do
    []
  end

  def self.notifiable_types
    (@@notifiable_types + RailsNotice.config.default_notifiable_types).uniq
  end
end
