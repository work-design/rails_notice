class ReceiverChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "#{current_receiver.class.base_class.name}:#{current_receiver.id}" if current_receiver
  end

  def unsubscribed
  end
  
end
