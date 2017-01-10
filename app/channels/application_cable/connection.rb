class ApplicationCable::Connection < ActionCable::Connection::Base
  identified_by :current_user

  def connect
    self.current_user = find_verified_user
  end

  protected
  def find_verified_user
    if session['user_id']
      current_user = User.find_by id: session['user_id']
    else
      current_user = nil
    end

    if current_user
      current_user
    else
      reject_unauthorized_connection
    end
  end

  def session
    session_key = Rails.application.config.session_options[:key]
    cookies.encrypted[session_key]
  end

end
