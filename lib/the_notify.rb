require 'the_notify/engine'
require 'the_notify/config'

module TheNotify
  mattr_writer :notifiable_types do
    []
  end

  def self.notifiable_types
    (@@notifiable_types + TheNotify.config.default_notifiable_types).uniq
  end
end
