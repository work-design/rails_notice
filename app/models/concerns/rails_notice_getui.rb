module RailsNoticeGetui

  def getui_pusher
    return @getui_pusher if defined?(@getui_pusher)
    @getui_pusher = IGeTui.pusher('X1HEFkU8ID6p59ycdbql91', 'NxWOzrhZ6j7O2AvE7w1Dq3', 'B3u6uQUsHx6FQ3Y8134r2A')
  end


  def send_to_getui
    template = IGeTui::NotificationTemplate.new
    template.logo = 'D_about_logo'
    template.title = self.title
    template.text = self.body

    single_message = IGeTui::SingleMessage.new
    single_message.data = template

    client = IGeTui::Client.new(receiver.getui_token)
    getui_pusher.push_message_to_single(single_message, client)
  end


end
