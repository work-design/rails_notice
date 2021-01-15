module Notice
  module Send::Getui

    def send_out
      super if defined? super

      return unless receiver.getui_token
      payload = { id: self.id, link: self.link }
      apns = Getui::Apns.new(self.body, title: self.title, payload: payload)
      message = Getui::Message::Transmission.new(apns: apns)

      Getui.push_single(receiver.getui_token, message)
    end

  end
end
