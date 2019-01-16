class Notice::Api::BaseController < RailsNotice.config.api_class.constantize
  before_action :require_login

  def current_receiver
    @current_receiver ||= send(RailsNotice.config.current_receiver)
  end

end
