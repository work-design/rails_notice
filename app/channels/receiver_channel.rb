class ReceiverChannel < ApplicationCable::Channel
  
  def subscribed
    if current_receiver.is_a?(AuthorizedToken)
      stream_from "#{current_receiver.token}"
    else
      stream_from "#{current_receiver}"
    end
  end

  def unsubscribed
  end
  
end
