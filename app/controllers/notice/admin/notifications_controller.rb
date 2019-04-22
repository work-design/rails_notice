class Notice::Admin::NotificationsController < Notice::Admin::BaseController
  before_action :set_notification, only: [:show, :push, :email, :edit, :update, :destroy]

  def index
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

    if @notification.save
      redirect_to admin_notifications_url(receiver_id: @notification.receiver_id, receiver_type: @notification.receiver_type)
    else
      render :new
    end
  end

  def update
    if @notification.update(notification_params)
      redirect_to admin_notifications_url(receiver_id: @notification.receiver_id, receiver_type: @notification.receiver_type)
    else
      render :edit
    end
  end

  def destroy
    @notification.destroy
    redirect_to admin_notifications_url(receiver_id: @notification.receiver_id, receiver_type: @notification.receiver_type)
  end

  private
  def q_params
    q = {}.with_indifferent_access
    q.merge! params.permit(:receiver_type, :receiver_id)
    q.merge! params.fetch(:q, {}).permit(:id, :'body-like', :receiver_type, :receiver_id)
    q
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params[:notification].permit(
      :title,
      :body,
      :link,
      :read_at
    )
  end

end
