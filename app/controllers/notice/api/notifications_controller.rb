class Notice::Api::NotificationsController < Notice::Api::BaseController
  before_action :set_notification, only: [:show, :destroy]
  before_action :set_receiver, only: [:index, :read_all]

  def index
    @notifications = @receiver.received_notifications.order(read_at: :asc)
    if params[:scope] == 'have_read'
      @notifications = @notifications.have_read
    else
      @notifications = @notifications.unread
    end
    @notifications = @notifications.page(params[:page])
  end

  def read_all
    @notifications = @receiver.received_notifications
    @notifications.update_all(read_at: Time.now)
    @count = Notification.update_unread_count(@receiver)
    render json: { count: @count }
  end

  def show
    @notification.make_as_read
  end

  def destroy
    @notification.destroy
  end

  private
  def set_receiver
    @receiver = current_receiver
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end

end
