class Notice::My::NotificationsController < Notice::My::BaseController
  before_action :set_notification, only: [:show, :url, :read, :edit, :update, :destroy]
  before_action :set_receiver, only: [:index, :read_all]
  protect_from_forgery except: :read

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.permit(:notifiable_type, :official)
    @notifications = @receiver.received_notifications.order(read_at: :asc)
    if params[:scope] == 'have_read'
      @notifications = @notifications.have_read
    elsif params[:scope] == 'unread'
      @notifications = @notifications.unread
    end
    @notifications = @notifications.default_where(q_params).page(params[:page]).per(params[:per])

    respond_to do |format|
      format.html
      format.js
      format.json
    end
  end

  def read_all
    @notifications = @receiver.received_notifications
    @notifications.update_all(read_at: Time.now)
    @count = Notification.reset_unread_count(@receiver)

    respond_to do |format|
      format.json { render json: { count: @count } }
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { @notification.make_as_read }
    end
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
    respond_to do |format|
      format.json
      format.html { redirect_to(notifications_path, notice: '删除成功。') }
    end
  end

  private
  def set_receiver
    @receiver = current_receiver
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end

end
