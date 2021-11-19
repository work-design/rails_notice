module Notice
  module Send::Wechat

    def send_out
      super if defined? super

      return unless wechat_template
      user.wechat_users.where(appid: wechat_app.appid).map do |wechat_user|
        wechat_notice = wechat_user.notices.build
        wechat_notice.template = wechat_template
        wechat_notice.subscribed = wechat_subscribeds.first
        wechat_notice.notification = self
        if wechat_app.is_a?(Wechat::PublicApp)
          wechat_notice.type = 'Wechat::PublicNotice'
        else
          wechat_notice.type = 'Wechat::ProgramNotice'
        end
        wechat_notice.save
        wechat_notice
      end
    end

    def wechat_app
      Wechat::App.where(organ_id: self.organ_id).default
    end

    def wechat_template
      template_config = Wechat::TemplateConfig.find_by(notifiable_type: self.notifiable_type, code: self.code)
      wechat_app.wechat_templates.find_by(template_config_id: template_config.id) if template_config
    end

  end
end
