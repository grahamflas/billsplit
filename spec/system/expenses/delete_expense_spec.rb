require "rails_helper"

RSpec.describe "Delete expense", type: :system, js: true do
  describe "deleting an expense" do
    scenario "user clicks kebab menu, chooses to delete the expense, confirms, sees the balance is updated and expense is no longer in the feed" do
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
        expect(page).to have_content("2,00 €")
        expect(page).to have_content("You are settled up")
        expect(page).to have_content("Jenna Maroney is settled up")
      end

      within "#open-expenses-count" do
        expect(page).to have_content(2)
      end

      within "#open-expenses" do
        expect(page).to have_content(expense_1.reference)
      end

      find("#edit-expense-#{expense_1.id}").click

      within "#expense-#{expense_1.id}" do
        expect(page).to have_button("Edit")
        expect(page).to have_button("Delete")
      end

      click_button("Delete")

      expect(page).to have_content("Are you sure?")

      find(
        "button[aria-label='Delete expense #{expense_1.reference}']"
      ).click

      expect(expense_1.reload.status).to eq("deleted")

      within "#balances" do
        expect(page).to have_content("1,00 €")
        expect(page).to have_content("You owe 0,50 €")
        expect(page).to have_content("Jenna Maroney receives 0,50 €")
      end

      within "#open-expenses-count" do
        expect(page).to have_content(1)
      end

      within "#open-expenses" do
        expect(page).not_to have_content(expense_1.reference)
      end

      click_button(id: "deleted-expenses-accordion")

      within "#deleted-expenses" do
        expect(page).to have_content(expense_1.reference)
      end
    end
  end
end
