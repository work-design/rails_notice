class TheNotifyAdmin::BaseController < TheNotify.config.admin_class.constantize
  #skip_before_action :verify_authenticity_token#, if: -> { request.content_type == 'application/json' }



end
