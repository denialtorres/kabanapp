# spec/factories/cards.rb
FactoryBot.define do
  factory :card do
    name { "Card Name" }
    position { 1 }
    description { "Card description" }
    association :column
  end
end
