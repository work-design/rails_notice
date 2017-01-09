class Admin::NotificationsController < Admin::BaseController
  before_action :set_user
  before_action :set_notification, only: [:show, :push, :edit, :update, :destroy]

  def index
    @notifications = @user.notifications.page(params[:page])
  end

  def show
  end

  def push
    @notification.process_job
    redirect_to admin_user_notifications_url(@user)
  end

  def new
    @notification = @user.notifications.build
  end

  def edit
  end

  def create
    @notification = @user.notifications.build(notification_params)

    if @notification.save
      redirect_to admin_user_notifications_url(@user), notice: 'User notification was successfully created.'
    else
      render :new
    end
  end

  def update
    if @notification.update(notification_params)
      redirect_to admin_user_notifications_url(@user), notice: 'User notification was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @notification.destroy
    redirect_to admin_user_notifications_url(@user), notice: 'User notification was successfully destroyed.'
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params[:notification].permit(:title, :body, :link)
  end

end
