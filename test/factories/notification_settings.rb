FactoryBot.define do
  factory :notification_setting do
    id { 1 }
    receiver_type { 'User' }
    receiver_id { 1 }
    notifiable_types []
    showtime { 1 }
    accept_email { false }
    created_at { "2018-09-28 15:15:45" }
    updated_at { "2018-09-28 15:15:45" }
  end
end
