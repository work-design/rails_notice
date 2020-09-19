class Notice::Admin::NotificationSettingsController < Notice::Admin::BaseController
  before_action :set_notification_setting, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}
    q_params.merge! params.permit(:id)
    @notification_settings = NotificationSetting.default_where(q_params).order(id: :desc).page(params[:page])
  end

  def new
    @notification_setting = NotificationSetting.new
  end

  def create
    @notification_setting = NotificationSetting.new(notification_setting_params)

    unless @notification_setting.save
      render :new, locals: { model: @notification_setting }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @notification_setting.assign_attributes(notification_setting_params)

    unless @notification_setting.save
      render :edit, locals: { model: @notification_setting }, status: :unprocessable_entity
    end
  end

  def destroy
    @notification_setting.destroy
  end

  private
  def set_notification_setting
    @notification_setting = NotificationSetting.find(params[:id])
  end

  def notification_setting_params
    params.fetch(:notification_setting, {}).permit(
      :showtime,
      :accept_email,
      notifiable_types: []
    )
  end

end
