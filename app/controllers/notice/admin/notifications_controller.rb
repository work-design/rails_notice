class Notice::Admin::NotificationsController < Notice::Admin::BaseController
  before_action :set_notification, only: [:show, :push, :email, :edit, :update, :destroy]

  def index
    q_params = {
      archived: false
    }
    q_params.merge! params.permit(:archived, :receiver_type, :receiver_id, :notifiable_type, :notifiable_id)
    @notifications = Notification.default_where(q_params).page(params[:page])
  end

  def show
  end

  def push
    @notification.process_job
    head :ok
  end

  def email
    @notification.send_email
    head :ok
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
    
    if @notification.save
      render :edit, locals: { model: @notification }, status: :unprocessable_entity
    end
  end

  def destroy
    @notification.destroy
  end

  private
  def q_params
    q = {}
    q.merge! params.permit(:receiver_type, :receiver_id)
    q.merge! params.permit(:id, :'body-like', :receiver_type, :receiver_id)
    q
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
