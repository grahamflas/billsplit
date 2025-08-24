FactoryBot.define do
  factory :expense do
    user { nil }
    group { nil }
    amount { 1 }
  end
end
