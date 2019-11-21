class ReceiverChannel < ApplicationCable::Channel
  
  def subscribed
    if verified_receiver.is_a?(AuthorizedToken)
      stream_from "#{verified_receiver.token}"
    else
      stream_from "#{verified_receiver}"
    end
  end

  def unsubscribed
  end
  
end
