FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "testuser#{n}@email.com" }
    password { "password" }
    sequence(:first_name) { |n| "User#{n} First Name" }
    sequence(:last_name) { |n| "User#{n} Last Name" }
  end
end
