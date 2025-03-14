# spec/factories/cards.rb
FactoryBot.define do
  factory :card do
    name { "Card Name" }
    description { "Card description" }
    association :column
  end
end
