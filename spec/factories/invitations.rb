FactoryBot.define do
  factory :invitation do
    group { nil }
    creator { nil }
    invitee { nil }
    invitee_email { "MyString" }
    status { 1 }
  end
end
