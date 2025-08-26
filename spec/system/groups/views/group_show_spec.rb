require "rails_helper"

RSpec.describe "Group Show Page", type: :system, js: true do
  scenario "displays group name, a list of members, a list of expenses" do
    group = create(:group, name: "Roommates Group")

    user_1 = create(:user, groups: [ group ])
    user_2 = create(:user, groups: [ group ])

    rent = create(
      :expense,
      reference: "Rent",
      amount: 1000,
      group:,
      user: user_1,
    )
    utilities = create(
      :expense,
      reference: "Utilities",
      amount: 225,
      group:,
      user: user_1,
    )
    cleaning = create(
      :expense,
      reference: "Cleaning Supplies",
      amount: 15,
      group:,
      user: user_2,
    )
    groceries = create(
      :expense,
      reference: "Groceries",
      amount: 100,
      group:,
      user: user_2,
    )

    sign_in user_1
    visit group_path(group)

    expect(page).to have_content(group.name)

    expect(page).to have_content("Group members")
    expect(page).to have_content(user_1.email)
    expect(page).to have_content(user_2.email)

    expect(page).to have_content("Dues")


    expect(page).to have_content("Expenses")
    expect(page).to have_content(rent.reference)
    expect(page).to have_content(utilities.reference)
    expect(page).to have_content(cleaning.reference)
    expect(page).to have_content(groceries.reference)

    within "#expense-#{rent.id}" do
      expect(page).to have_content("Amount: #{rent.amount}")
      expect(page).to have_content("Paid by: #{rent.user.email}")
    end
  end
end
