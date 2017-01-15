class Admin::NotificationsController < Admin::BaseController
  before_action :set_receiver
  before_action :set_notification, only: [:show, :push, :edit, :update, :destroy]

  def index
    if @receiver
      @notifications = @receiver.notifications.page(params[:page])
    else
      @notifications = Notification.page(params[:page])
    end
  end

  def show
  end

  def push
    @notification.process_job
    head :ok
  end

  def new
    @notification = @receiver.notifications.build
  end

  def edit
  end

  def create
    @notification = @receiver.notifications.build(notification_params)

    if @notification.save
      redirect_to admin_notifications_url(receiver_id: @receiver.id, receiver_type: @receiver.class.name), notice: 'User notification was successfully created.'
    else
      render :new
    end
  end

  def update
    if @notification.update(notification_params)
      redirect_to admin_notifications_url(receiver_id: @receiver.id, receiver_type: @receiver.class.name), notice: 'User notification was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @notification.destroy
    redirect_to admin_notifications_url(receiver_id: @receiver.id, receiver_type: @receiver.class.name), notice: 'User notification was successfully destroyed.'
  end

  private
  def set_receiver
    if params[:receiver_type]
      @receiver = params[:receiver_type].constantize.find(params[:receiver_id])
    end
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params[:notification].permit(:title, :body, :link)
  end

end
