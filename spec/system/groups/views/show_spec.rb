require "rails_helper"

RSpec.describe "Group Show Page", type: :system, js: true do
  scenario "displays group name, a list of members, their balances, and a list of expenses" do
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

    expect(page).to have_content("Balances")

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

  describe "Balances section" do
    scenario "shows how much each group member owes or is owed" do
      group_1 = create(:group, name: "Group 1")

      group_1_user_1 = create(
        :user,
        groups: [ group_1 ],
      )
      group_1_user_2 = create(
        :user,
        groups: [ group_1 ],
      )

      create(
        :expense,
        user: group_1_user_1,
        group: group_1,
        amount: 100
      )

      create(
        :expense,
        user: group_1_user_2,
        group: group_1,
        amount: 15
      )

      sign_in group_1_user_1

      visit group_path(group_1)

      expect(page).to have_content("Balances")
      expect(page).to have_content("#{group_1_user_1.email} is owed 42.50")
      expect(page).to have_content("#{group_1_user_2.email} owes 42.50")
    end
  end

  context "when no expenses have been added to the group" do
    scenario "does not show the balances section" do
      group = create(:group)
      user_1 = create(:user, groups: [ group ])
      user_2 = create(:user, groups: [ group ])

      sign_in user_1

      visit group_path(group)

      expect(page).to have_content(group.name)
      expect(page).to have_content(user_1.email)
      expect(page).to have_content(user_2.email)

      expect(page).not_to have_content("Balances")
      expect(page).not_to have_content("Expenses")
    end
  end

  context "when expenses exist, but they are equally shared (each member has paid their share and no one is owed anything)" do
    scenario "displays 'all settled up copy'" do
      group = create(:group)

      user_1 = create(:user, groups: [ group ])
      user_2 = create(:user, groups: [ group ])

      create(
        :expense,
        amount: 1,
        user: user_1,
        group:,
      )
      create(
        :expense,
        amount: 1,
        user: user_2,
        group:,
      )

      sign_in user_1

      visit group_path(group)

      expect(page).to have_content("#{user_1.email} is all settled up")
      expect(page).to have_content("#{user_2.email} is all settled up")
    end
  end

  describe "creating a new expense" do
    context "when no expenses exist" do
      scenario "user sees link to add a new expense" do
        group = create(:group)
        user = create(:user, groups: [ group ])

        sign_in user

        visit group_path(group)

        expect(page).to have_link("+ Add Expense", href: new_expense_path)
      end
    end

    context "when expenses exist" do
      scenario "user sees link under the expenses heading to add a new expense" do
        group = create(:group)
        user = create(:user, groups: [ group ])
        _other_user = create(:user, groups: [ group ])


        create(
          :expense,
          user:,
          group:
        )

        sign_in user

        visit group_path(group)

        within "#expenses" do
          expect(page).to have_link("+ Add Expense", href: new_expense_path)
        end
      end
    end
  end
end
