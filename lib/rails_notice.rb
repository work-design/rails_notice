require 'rails_notice/engine'
require 'rails_notice/config'
require 'rails_notice/active_record'

module RailsNotice
  mattr_accessor :notifiable_types, default: {}
  
  def self.xxx
    notifiable_types.map { |i| i}
  end
  
end
