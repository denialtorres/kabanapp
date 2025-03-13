# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@mail.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
