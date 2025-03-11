# spec/factories/boards.rb
FactoryBot.define do
  factory :board do
    name { "Board Name" }
    association :user
  end
end
