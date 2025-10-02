require "rails_helper"

RSpec.describe "Group Show Page", :aggregate_failures, type: :system, js: true  do
  context "when the group is active" do
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

      expect(page).to have_content(user_1.full_name)
      expect(page).to have_content(user_2.full_name)

      expect(page).to have_content("Total Expenses")
      expect(page).to have_content("1.340,00 €")

      expect(page).to have_content(rent.reference)
      expect(page).to have_content(utilities.reference)
      expect(page).to have_content(cleaning.reference)
      expect(page).to have_content(groceries.reference)

      within "#expense-#{rent.id}" do
        expect(page).to have_content("1.000,00 €")
        expect(page).to have_content("Paid by #{rent.user.full_name}")
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

        expect(page).to have_content("You receive 42,50 €")
        expect(page).to have_content("#{group_1_user_2.full_name} owes 42,50 €")
      end
    end

    context "when no expenses have been added to the group" do
      scenario "It shows that the users are settled up" do
        group = create(:group)
        user_1 = create(:user, groups: [ group ])
        user_2 = create(:user, groups: [ group ])

        sign_in user_1

        visit group_path(group)

        expect(page).to have_content(group.name)
        expect(page).to have_content(user_1.first_name)
        expect(page).to have_content(user_2.first_name)

        expect(page).to have_content("You are settled up")
        expect(page).to have_content("#{user_2.full_name} is settled up")
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

        expect(page).to have_content("You are settled up")
        expect(page).to have_content("#{user_2.full_name} is settled up")

        expect(page).not_to have_content("#{user_1.full_name} is all settled up")
      end
    end

    scenario "does not show deleted expenses" do
      group = create(:group)

      user = create(:user, groups: [ group ])

      expense = create(
        :expense,
        reference: "Open Expense",
        amount: 1,
        group:,
        user:
      )

      deleted_expense = create(
        :expense,
        :deleted,
        reference: "Deleted Expense",
        amount: 1,
        group:,
        user:
      )

      sign_in user

      visit group_path(group)

      within "#total-expenses" do
        expect(page).to have_content("1,00 €")
      end

      within "#open-expenses" do
        expect(page).not_to have_content(deleted_expense.reference)
      end
    end

    scenario "user sees link to add a new expense" do
      group = create(:group)
      user = create(:user, groups: [ group ])

      sign_in user

      visit group_path(group)

      expect(page).to have_link(
        "+ Add Expense",
        href: new_expense_path(group_id: group.id),
      )
    end
  end

  context "when the group is archived" do
    scenario "has a link to go back to archived groups page, does not show Add Expense button, has a button to restore the group" do
      group = create(:group, :archived)
      user = create(:user, groups: [ group ])

      sign_in user

      visit group_path(group)

      expect(page).to have_link("Back to My Archived Groups", href: archived_groups_path )

      expect(page).to have_css("span", text: "Archived")

      expect(page).not_to have_link("+ Add Expense")

      expect(page).not_to have_link("Restore this group")
    end
  end
end
