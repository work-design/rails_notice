module TheNotifyController
  extend ActiveSupport::Concern

  included do
    before_action :set_receiver_id
  end

  def set_receiver_id
    cookies.signed['receiver_id'] = current_user&.id
  end

end