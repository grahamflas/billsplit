FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Group #{n}" }
  end

  trait :archived do
    archived_on { Time.now }
  end
end
