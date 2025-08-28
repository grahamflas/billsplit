FactoryBot.define do
  factory :expense do
    group
    user
    amount { 1 }
    sequence(:reference) { |n| "Reference #{n}" }

    after(:build) do |expense|
      unless expense.user.groups.include?(expense.group)
        expense.user.groups << expense.group
      end
    end
  end
end
