FactoryBot.define do
  factory :user_card do
    association :card
    association :user
  end
end
