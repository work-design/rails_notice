# prepend this module
module TheNotifyConnection

  def self.prepended(model)
    model.identified_by :current_receiver
  end

  def connect
    self.current_receiver = find_verified_receiver
    super
  end

  protected
  def find_verified_receiver
    if session['receiver_id'] && session['receiver_type']
      session['receiver_type'].constantize.find session['receiver_id']
    else
      logger.error 'An unauthorized connection attempt was rejected'
      nil
    end
  end

  def session
    session_key = Rails.configuration.session_options[:key]
    cookies.encrypted[session_key]
  end

end
