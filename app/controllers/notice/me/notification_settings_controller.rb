class Notice::Me::NotificationSettingsController < Notice::Me::BaseController
  before_action :set_notification_setting, only: [:show, :edit, :update]

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

  private
  def set_notification_setting
    @notification_setting = current_user.notification_setting || current_user.build_notification_setting
  end

  def notification_setting_params
    params.fetch(:notification_setting, {}).permit(
      :showtime,
      :accept_email
    )
  end

end
