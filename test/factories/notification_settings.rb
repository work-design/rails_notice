FactoryBot.define do
  factory :notification_setting do
    receiver_type { 'User' }
    receiver_id { 1 }
    notifiable_types { [] }
    showtime { 1 }
    accept_email { false }
  end
end
