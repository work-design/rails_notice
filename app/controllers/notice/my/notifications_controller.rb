module Notice
  class My::NotificationsController < My::BaseController
    before_action :set_notification, only: [:show, :url, :read, :update, :archive, :destroy]

    def index
      q_params = {
        archived: false
      }
      q_params.merge! default_params

      current_user.apply_pending_annunciations
      @notifications = current_user.notifications.order(read_at: :asc)
      if params[:scope] == 'readed'
        @notifications = @notifications.readed
      elsif params[:scope] == 'unread'
        @notifications = @notifications.unread
      end
      @notifications = @notifications.default_where(q_params).page(params[:page]).per(params[:per])
    end

    def readed
      q_params = {}
      @notifications = current_user.notifications.where.not(read_at: nil).order(read_at: :asc).default_where(q_params).page(params[:page]).per(params[:per])
    end

    def read_all
      if params[:page]
        @notifications = current_user.notifications.default_where(q_params).page(params[:page]).per(params[:per])
      else
        @notifications = current_user.notifications.default_where(q_params)
      end
      @notifications.update_all(read_at: Time.current)
      current_user.reset_unread_count
    end

    def show
      @notification.make_as_read
    end

    def url
      @notification.make_as_read
      redirect_to @notification.link
    end

    def read
      @notification.make_as_read
    end

    def archive
      @notification.archive
    end

    private
    def q_params
      q_params = {}
      q_params.merge! params.permit(:notifiable_type, :official)
    end

    def notification_params
      params.fetch(:notification, {}).permit!
    end

    def set_notification
      @notification = Notification.find(params[:id])
    end

  end
end
