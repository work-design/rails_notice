module Notice
  module Controller::Board
    extend ActiveSupport::Concern

    included do
      layout 'board'
    end

  end
end
