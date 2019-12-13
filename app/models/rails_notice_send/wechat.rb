module RailsNoticeSend::Wechat
  extend ActiveSupport::Concern
  included do
  
  end
  
  def send_out
    return unless receiver.getui_token
    payload = { id: self.id, link: self.link }
    apns = Getui::Apns.new(self.body, title: self.title, payload: payload)
    message = Getui::Message::Transmission.new(apns: apns)

    Getui.push_single(receiver.getui_token, message)
  end
  
  def wechat_app
    WechatApp.where(organ_id: self.organ_id).valid.take
  end
  
  def wechat_notice
    wechat_app.wechat_notices.find_by(notifiable_type: self.notifiable_type, code: self.code)
  end
  
end
