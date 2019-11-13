FactoryBot.define do
  factory :notification do
    receiver_type { "MyString" }
    receiver_id { 1 }
    notifiable_type { "MyString" }
    notifiable_id { 1 }
    code { "MyString" }
    state { 1 }
    title { "MyString" }
    body { "MyString" }
    link { "MyString" }
    sending_at { "2018-09-28 15:12:25" }
    sent_at { "2018-09-28 15:12:25" }
    sent_result { "MyString" }
    read_at { "2018-09-28 15:12:25" }
    verbose { false }
    cc_emails { "MyString" }
  end
end
