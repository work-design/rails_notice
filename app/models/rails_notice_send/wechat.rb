module RailsNoticeSend::Wechat
  extend ActiveSupport::Concern

  included do

  end

  def send_out
    return unless wechat_template
    wechat_notice = wechat_template.wechat_notices.build
    wechat_notice.wechat_subscribed = receiver.wechat_subscribeds
    wechat_notice.notifiaction = self
    wechat_notice.save
  end

  def wechat_app
    WechatApp.where(organ_id: self.organ_id).valid.take
  end

  def wechat_template

  end

  def public_template
    PublicTemplate.find_by(notifiable_type: self.notifiable_type, code: self.code)
  end

end
