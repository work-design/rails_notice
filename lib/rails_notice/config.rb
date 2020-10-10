require 'active_support/configurable'

module RailsNotice
  include ActiveSupport::Configurable

  configure do |config|
    config.link_host = ''
  end

end
