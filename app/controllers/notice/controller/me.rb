module Notice
  module Controller::Me
    extend ActiveSupport::Concern

    included do
      layout 'me'
    end

  end
end
