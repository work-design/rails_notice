require 'the_notify/engine'
require 'the_notify/config'

module TheNotify
  mattr_accessor :notifiable_types do
    []
  end
end
