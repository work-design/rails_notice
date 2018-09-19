class RailsNoticeMy::NotificationSettingsController < RailsNoticeMy::BaseController
  before_action :set_notification_setting, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    if @notification_setting.update(notification_setting_params)
      redirect_to notification_settings_url(receiver: params[:receiver]), notice: 'Notification setting was successfully updated.'
    else
      render :edit
    end
  end

  private
  def set_notification_setting
    @receiver = current_receiver
    @notification_setting = @receiver.notification_setting || @receiver.build_notification_setting
  end

  def notification_setting_params
    params.fetch(:notification_setting, {}).permit(:showtime, :accept_email)
  end

end
