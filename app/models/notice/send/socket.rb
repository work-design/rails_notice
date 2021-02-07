module Notice
  module Send::Socket

    def send_out
      super if defined? super

      return unless user
      user.authorized_tokens.each do |authorized_token|
        ActionCable.server.broadcast(authorized_token.token, {
          id: id,
          body: body,
          count: user.unread_count,
          link: link,
          showtime: user.showtime
        })
        self.notification_sendings.find_or_create_by(way: 'websocket', sent_to: authorized_token.token)
      end
    end

  end
end
