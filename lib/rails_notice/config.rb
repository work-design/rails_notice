require 'active_support/configurable'

module RailsNotice
  include ActiveSupport::Configurable

  configure do |config|
    config.default_send_email = true
    config.link_host = ''
  end

end
