require 'active_support/configurable'

module RailsNotice
  include ActiveSupport::Configurable

  configure do |config|
    config.admin_class = 'Admin::BaseController'
    config.my_class = 'My::BaseController'
    config.default_notifiable_types = []
    config.default_send_email = true
  end

end