require 'active_support/configurable'

module RailsNotice
  include ActiveSupport::Configurable

  configure do |config|
    config.admin_controller = 'AdminController'
    config.my_controller = 'MyController'
    config.default_send_email = true
    config.link_host = ''
  end

end
