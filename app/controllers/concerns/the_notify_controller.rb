module TheNotifyController
  extend ActiveSupport::Concern

  included do
    before_action :set_receiver
  end

  def set_receiver
    session['receiver_type'] = current_user.class.name
    session['receiver_id'] = current_user&.id
  end

end