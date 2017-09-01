class Admin::TheNotifyController < TheNotify.config.admin_class.constantize
  skip_before_action :verify_authenticity_token#, if: -> { request.content_type == 'application/json' }

  def index

  end

end
