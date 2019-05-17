module RailsNotice::Controller
  extend ActiveSupport::Concern

  included do
    before_action :set_receiver
    helper_method :current_receiver
  end

  def set_receiver
    if current_receiver
      session['receiver_type'] = current_receiver.class.name
      session['receiver_id'] = current_receiver.id
    end
  end

  def current_receiver
    current_user
  end

end
