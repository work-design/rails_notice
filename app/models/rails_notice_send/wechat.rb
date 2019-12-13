module RailsNoticeSend::Wechat

  def send_out
    return unless receiver.getui_token
    payload = { id: self.id, link: self.link }
    apns = Getui::Apns.new(self.body, title: self.title, payload: payload)
    message = Getui::Message::Transmission.new(apns: apns)

    Getui.push_single(receiver.getui_token, message)
  end
  
  def wechat_app

  end
  
end
