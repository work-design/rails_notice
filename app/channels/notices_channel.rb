class NoticesChannel < ApplicationCable::Channel

  def subscribed
    stream_from "#{current_receiver.class.name}:#{current_receiver&.id}"
  end

end
