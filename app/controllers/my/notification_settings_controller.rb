class My::NotificationSettingsController < My::TheNotifyController
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
    receiver_method = params[:receiver].presence || :current_user
    @receiver = send receiver_method
    @notification_setting = @receiver.notification_setting || @receiver.build_notification_setting
  end

  def notification_setting_params
    params.fetch(:notification_setting, {}).permit(:showtime)
  end

end
