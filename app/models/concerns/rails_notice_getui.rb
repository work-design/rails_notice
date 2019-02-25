module RailsNoticeGetui
  Getui.app_id = 'X1HEFkU8ID6p59ycdbql91'
  Getui.app_key = 'NxWOzrhZ6j7O2AvE7w1Dq3'
  Getui.master_secret = 'B3u6uQUsHx6FQ3Y8134r2A'



  def send_to_getui
    apns = Getui::Apns.new(self.body, title: self.title)
    message = Getui::Message::Transmission.new('请填写透传内容')
    message.apns = apns

    Getui.push_single(receiver.getui_token, message)
  end


end
