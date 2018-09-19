class RailsNoticeMy::NotificationsController < RailsNoticeMy::BaseController
  before_action :set_notification, only: [:show, :url, :read, :edit, :update, :destroy]
  before_action :set_receiver, only: [:index, :read_all]
  protect_from_forgery except: :read

  def index
    @notifications = @receiver.received_notifications.order(read_at: :asc)
    if params[:scope] == 'have_read'
      @notifications = @notifications.have_read
    else
      @notifications = @notifications.unread
    end
    @notifications = @notifications.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def read_all
    @notifications = @receiver.received_notifications
    @notifications.update_all(read_at: Time.now)
    @count = Notification.update_unread_count(@receiver)
  end

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(params[:notification].permit!)

    if @notification.save
      redirect_to(notifications_path, notice: 'Notification 创建成功。')
    else
      render action: 'new'
    end
  end

  def show
  end

  def url
    @notification.make_as_read
    redirect_to @notification.link
  end

  def read
    @notification.make_as_read
  end

  def edit
  end

  def update
    if @notification.update(params[:notification].permit!)
      redirect_to(notifications_path, notice: 'Notification 更新成功。')
    else
      render action: 'edit'
    end
  end

  def destroy
    @notification.destroy
    redirect_to(notifications_path, notice: "删除成功。")
  end

  private
  def set_receiver
    @receiver = current_receiver
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end

end
