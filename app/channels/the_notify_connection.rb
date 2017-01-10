# prepend this module
module TheNotifyConnection
  extend ActiveSupport::Concern

  def self.prepended(model)
    model.identified_by :current_receiver_id
  end

  def connect
    self.current_receiver_id = cookies.encrypted['receiver_id']
    super
  end

  protected
  def find_verified_receiver
    receiver_id = cookies.encrypted['receiver_id']

    if receiver_id
      User.find_by id: receiver_id
    end
  end


end
