require "rails_helper"

RSpec.describe "Edit expense", type: :system, js: true do
  describe "editing an expense" do
    scenario "user clicks kebab menu, chooses to edit the expense, submits form, sees edited expense in feed" do
      group = create(:group)
      user_1 = create(
        :user,
        groups: [ group ],
        first_name: "Liz",
        last_name: "Lemon",
      )
      user_2 = create(
        :user,
        groups: [ group ],
        first_name: "Jenna",
        last_name: "Maroney"
      )

      expense_1 = create(
        :expense,
        amount: 1,
        reference: "Expense 1",
        user: user_1,
        group:
      )
      _expense_2 = create(
        :expense,
        amount: 1,
        reference: "Expense 2",
        user: user_2,
        group:
      )

      sign_in user_1

      visit group_path(group)

      within "#balances" do
        expect(page).to have_content("$2.00")
        expect(page).to have_content("You are settled up")
        expect(page).to have_content("Jenna Maroney is settled up")
      end

      find("#edit-expense-#{expense_1.id}").click

      within "#expense-#{expense_1.id}" do
        expect(page).to have_button("Edit")
        expect(page).to have_button("Delete")
      end

      click_button("Edit")

      expect(page).to have_content("Edit #{expense_1.reference}")

      fill_in("Reference", with: "#{expense_1.reference} - updated")
      fill_in("Amount", with: 10)

      click_button "submit"

      expect(page).to have_content("Updated expense: #{expense_1.reference}")

      expect(page).to have_content("$11.00")
      expect(page).to have_content("You receive $4.50")
      expect(page).to have_content("Jenna Maroney owes $4.50")

      within "#expense-#{expense_1.id}" do
        expect(page).to have_content("Expense 1 - updated")
        expect(page).to have_content("$10")
      end
    end
  end
end
