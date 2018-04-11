require 'active_support/configurable'

module TheNotify
  include ActiveSupport::Configurable

  configure do |config|
    config.admin_class = 'Admin::BaseController'
    config.my_class = 'My::BaseController'
    config.default_notifiable_types = []
  end

end