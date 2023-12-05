module Notice
  module Send::Socket

    def send_out
      super if defined? super

      if user
        ReceiverChannel.broadcast_to(user_id, {
          id: id,
          body: body,
          count: user.unread_count,
          link: link,
          showtime: user.showtime
        })
        self.notification_sendings.find_or_create_by(way: 'websocket', sent_to: user_id)
      elsif member
        ReceiverChannel.broadcast_to(member.identity, {
          id: id,
          body: body,
          count: member.unread_count,
          link: link,
          showtime: member.showtime
        })
        self.notification_sendings.find_or_create_by(way: 'websocket', sent_to: member_id)
      end
    end

  end
end
