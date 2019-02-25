module RailsNoticeGetui
  Getui.app_id = 'X1HEFkU8ID6p59ycdbql91'
  Getui.app_key = 'NxWOzrhZ6j7O2AvE7w1Dq3'
  Getui.master_secret = 'B3u6uQUsHx6FQ3Y8134r2A'



  def send_to_getui
    message = Getui::Apns.new(self.body, self.title)

    Getui.push_single(receiver.getui_token, message)
  end


end
