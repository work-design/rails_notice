module Notice
  class Me::NotificationsController < Me::BaseController
    before_action :set_notification, only: [:show, :url, :read, :update, :archive, :destroy]

    def index
      q_params = {
        archived: false
      }
      if params.key? 'read_at-not'
        q_params.merge! 'read_at-not': nil, allow: { 'read_at-not': nil }
      else
        q_params.merge! read_at: nil, allow: { read_at: nil }
      end

      current_member.apply_pending_annunciations
      @notifications = current_member.notifications.order(read_at: :asc).default_where(q_params).page(params[:page]).per(params[:per])
    end

    def read_all
      @notifications = current_user.notifications.default_where(q_params).page(params[:page]).per(params[:per])
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

    def update
      @notification.update(notification_params)

      unless @notification.save
        render :edit, locals: { model: @notification }, status: :unprocessable_entity
      end
    end

    def archive
      @notification.archive
    end

    def destroy
      @notification.destroy
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
