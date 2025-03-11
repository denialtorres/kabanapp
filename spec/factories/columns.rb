# spec/factories/columns.rb
FactoryBot.define do
  factory :column do
    name { "Column Name" }
    position { 1 }
    association :board
  end
end