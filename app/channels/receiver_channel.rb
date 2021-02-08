class ReceiverChannel < ApplicationCable::Channel

  def subscribed
    if verified_receiver.is_a?(Auth::AuthorizedToken)
      stream_from "receiver:#{verified_receiver.user_id}"
    else
      stream_from "#{verified_receiver}"
    end
  end

  def unsubscribed
  end

end
