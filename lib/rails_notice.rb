require 'rails_notice/engine'
require 'rails_notice/config'
require 'rails_notice/active_record'
require 'rails_notice/pusher/getui_helper'

module RailsNotice
  mattr_writer :notifiable_types do
    []
  end

  def self.notifiable_types
    (@@notifiable_types + RailsNotice.config.default_notifiable_types).uniq
  end
end
