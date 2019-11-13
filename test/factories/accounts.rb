FactoryBot.define do
  
  factory :account do
    user
    type { 'EmailAccount' }
    identity { 'test@work.design' }
    confirmed { false }
    primary { false }
  end
  
end
