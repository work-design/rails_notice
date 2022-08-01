module Notice
  class My::NotificationSettingsController < My::BaseController
    before_action :set_notification_setting, only: [:show, :edit, :update]

    private
    def set_notification_setting
      @notification_setting = current_user
    end

    def notification_setting_params
      params.fetch(:notification_setting, {}).permit(
        :showtime,
        :accept_email
      )
    end

  end
end

