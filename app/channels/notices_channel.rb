class NoticesChannel < ApplicationCable::Channel

  def subscribed
    stream_from "user:#{current_user.id}"
  end

end
