FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "testuser#{n}@email.com" }
    password { "password" }
  end
end
