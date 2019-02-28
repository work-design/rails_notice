class NotificationSettingResetJob < ApplicationJob
  queue_as :default

  def perform
    NotificationSetting.reset_counters
  end

end
