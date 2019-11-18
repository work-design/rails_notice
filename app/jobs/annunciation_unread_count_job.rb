class AnnunciationUnreadCountJob < ApplicationJob
  queue_as :default
  
  def perform(notification)
    notification.send_out
  end

end
