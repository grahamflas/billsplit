FactoryBot.define do
  factory :expense do
    user
    group
    amount { 1 }
    sequence(:reference) { |n| "Reference #{n}"}
  end
end
