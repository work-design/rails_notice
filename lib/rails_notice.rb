require 'rails_notice/engine'
require 'rails_notice/config'
require 'rails_notice/active_record'
require 'rails_notice/i18n_helper'

module RailsNotice
  mattr_accessor :notifiable_types, default: {}

  def self.xxx
    notifiable_types.map { |i| i}
  end

end

module Notice

  def self.use_relative_model_naming?
    true
  end

end
