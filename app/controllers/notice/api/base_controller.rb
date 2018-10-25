class Notice::Api::BaseController < RailsNotice.config.api_class.constantize
  before_action :require_login_from_token


  def current_receiver
    @current_receiver ||= send(RailsNotice.config.current_receiver)
  end

end
