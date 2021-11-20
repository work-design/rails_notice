module Notice
  module Send::Wechat

    def send_out
      super if defined? super

      return unless template_config
      user.wechat_users.default_where('app.organ_id': self.organ_id).map do |wechat_user|
        wechat_template = wechat_user.app.templates.find_by(template_config_id: template_config.id)
        next if wechat_template.nil?

        if wechat_user.app.is_a?(Wechat::PublicApp)
          wechat_notice = wechat_user.notices.build type: 'Wechat::PublicNotice'
        else
          wechat_notice = wechat_user.notices.build type: 'Wechat::ProgramNotice'
        end

        wechat_notice.template = wechat_template
        wechat_notice.msg_request = wechat_template.msg_requests.where(open_id: wechat_user.uid).first
        wechat_notice.notification = self
        wechat_notice.save
        wechat_notice
      end
    end

    def template_config
      return @template_config if defined? @template_config
      @template_config = Wechat::TemplateConfig.find_by(notifiable_type: self.notifiable_type, code: self.code)
    end

  end
end
