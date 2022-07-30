module Notice
  module Send::Wechat
    extend ActiveSupport::Concern

    included do
      belongs_to :template_config, ->(o) { where(notifiable_type: o.notifiable_type) }, class_name: 'Wechat::TemplateConfig', foreign_key: :code, primary_key: :code, optional: true
    end

    def send_out
      super if defined? super
      return unless template_config

      user.wechat_users.default_where('app.organ_id': self.organ_id).map do |wechat_user|
        wechat_template = template_config.templates.find_by(appid: wechat_user.appid)
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

  end
end
