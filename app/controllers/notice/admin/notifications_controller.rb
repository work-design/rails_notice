module Notice
  class Admin::NotificationsController < Admin::BaseController
    before_action :set_notification, only: [:show, :push, :email, :edit, :update, :destroy]

    def index
      q_params = {
        archived: false
      }
      q_params.merge! default_params
      q_params.merge! params.permit(:archived, :user_id, :notifiable_type, :notifiable_id, 'user.name-like')

      @notifications = Notification.default_where(q_params).page(params[:page])
    end

    def show
    end

    def push
      @notification.process_job
    end

    def email
      @notification.send_email
    end

    def new
      @notification = Notification.new
    end

    def edit
    end

    def create
      @notification = Notification.new(notification_params)

      unless @notification.save
        render :new, locals: { model: @notification }, status: :unprocessable_entity
      end
    end

    def update
      @notification.assign_attributes(notification_params)

      unless @notification.save
        render :edit, locals: { model: @notification }, status: :unprocessable_entity
      end
    end

    def destroy
      @notification.destroy
    end

    private
    def q_params
      q = {}
      q.merge! params.permit(:id, 'body-like', :user_id)
    end

    def set_notification
      @notification = Notification.find(params[:id])
    end

    def notification_params
      params.fetch(:notification, {}).permit(
        :title,
        :body,
        :link,
        :read_at
      )
    end

  end
end
