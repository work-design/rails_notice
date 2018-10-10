require 'active_support/configurable'

module RailsNotice
  include ActiveSupport::Configurable

  configure do |config|
    config.admin_class = 'AdminController'
    config.my_class = 'MyController'
    config.default_notifiable_types = []
    config.default_send_email = true
  end

end
