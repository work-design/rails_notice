class TheNotifyAdmin::NotificationSettingsController < TheNotifyAdmin::BaseController
  before_action :set_notification_setting, only: [:show, :edit, :update, :destroy]

  def index
    @notification_settings = Rails::Generators::ActiveModel.page(params[:page])
  end

  def new
    @notification_setting = NotificationSetting.new
  end

  def create
    @notification_setting = NotificationSetting.new(notification_setting_params)

    if @notification_setting.save
      redirect_to notification_settings_url, notice: 'Notification setting was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @notification_setting.update(notification_setting_params)
      redirect_to notification_settings_url, notice: 'Notification setting was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @notification_setting.destroy
    redirect_to notification_settings_url, notice: 'Notification setting was successfully destroyed.'
  end

  private
  def set_notification_setting
    @notification_setting = NotificationSetting.find(params[:id])
  end

  def notification_setting_params
    params.fetch(:notification_setting, {}).permit(:showtime, :accept_email)
  end

end
