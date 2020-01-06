module RailsNoticeSend::Wechat
  extend ActiveSupport::Concern

  included do

  end

  def send_out
    return unless wechat_template
    wechat_notice = wechat_template.wechat_notices.build
    wechat_notice.wechat_subscribed = receiver.wechat_subscribeds.first
    wechat_notice.notification = self
    wechat_notice.save
  end

  def wechat_app
    WechatProgram.where(organ_id: self.organ_id).default
  end

  def wechat_template
    template_config = TemplateConfig.find_by(notifiable_type: self.notifiable_type, code: self.code)
    wechat_app.wechat_templates.find_by(template_config_id: template_config.id) if template_config
  end

end
