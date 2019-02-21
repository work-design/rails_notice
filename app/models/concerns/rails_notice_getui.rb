module RailsNoticeGetui


  def getui_pusher
    pusher = IGeTui.pusher(your_app_id, your_app_key, your_master_secret)
  end


  def send_to_getui
    template = IGeTui::NotificationTemplate.new
    template.logo = 'push.png'
    template.title = self.title
    template.text = self.body

    single_message = IGeTui::SingleMessage.new
    single_message.data = template

    client = IGeTui::Client.new(receiver.getui_token)
    pusher.push_message_to_single(single_message, client)
  end


end
