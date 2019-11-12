class Notice::My::NotificationsController < Notice::My::BaseController
  before_action :set_notification, only: [:show, :url, :read, :update, :destroy]
  protect_from_forgery except: :read

  def index
    q_params = {}
    @notifications = current_receiver.received_notifications.order(read_at: :asc)
    if params[:scope] == 'have_read'
      @notifications = @notifications.have_read
    elsif params[:scope] == 'unread'
      @notifications = @notifications.unread
    end
    @notifications = @notifications.default_where(q_params).page(params[:page]).per(params[:per])
  end

  def read_all
    @notifications = current_receiver.received_notifications.default_where(q_params)
    @notifications.update_all(read_at: Time.current)
    @count = Notification.reset_unread_count(current_receiver)
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
