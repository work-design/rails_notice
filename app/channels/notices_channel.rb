class NoticesChannel < ApplicationCable::Channel

  def subscribed
    stream_from "receiver:#{current_receiver_id}"
  end

end
