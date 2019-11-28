module RailsNotice::NotifySetting
  extend ActiveSupport::Concern
  included do
    attribute :notifiable_type, :string
    attribute :code, :string
    attribute :notify_mailer, :string
    attribute :notify_method, :string
    attribute :only_verbose_columns, :string
    attribute :except_verbose_columns, :string
    attribute :cc_emails, :string
  end
  
end
