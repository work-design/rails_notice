module RailsNoticeSend::Wechat
  extend ActiveSupport::Concern

  included do

  end

  def send_out
    super if defined? super

    return unless wechat_template
    wechat_notice = wechat_template.wechat_notices.build
    wechat_notice.wechat_subscribed = user.wechat_subscribeds.first
    wechat_notice.notification = self
    if wechat_app.is_a?(WechatPublic)
      wechat_notice.type = 'PublicNotice'
    else
      wechat_notice.type = 'ProgramNotice'
    end
    wechat_notice.save
    wechat_notice
    #self.notification_sendings.find_or_create_by(way: 'wechat', sent_to: authorized_token.token)
  end

  def wechat_app
    WechatApp.where(organ_id: self.organ_id).default
  end

  def wechat_template
    template_config = TemplateConfig.find_by(notifiable_type: self.notifiable_type, code: self.code)
    wechat_app.wechat_templates.find_by(template_config_id: template_config.id) if template_config
  end

end
