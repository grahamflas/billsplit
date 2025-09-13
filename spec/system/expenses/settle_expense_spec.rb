require "rails_helper"

RSpec.describe "Settle Expenses", type: :system, js: true do
  scenario "User can settle open expenses" do
    group = create(:group)
    user = create(:user, groups: [group])
    other_user = create(:user, groups: [group])

    expense_1 = create(
      :expense,
      amount: 10,
      user:,
      group:
    )
    expense_2 = create(
      :expense,
      amount: 20,
      user: other_user,
      group:
    )

    balances = Balances.new(group:).compute

    sign_in user

    visit group_path(group)

    click_button("Settle open expenses")

    within "#settle-expenses-modal" do
      expect(page).to have_content("Settle expenses for #{group.name}")
      expect(page).to have_content("You are about to settle expenses for this group.")
      expect(page).to have_content("By proceeding")
    end

    within "#total-expenses-to-settle" do
      expect(page).to have_content(balances[:totalExpenses])
    end

    fill_in("note", with: "Paid with cash")

    click_button "settle"
  end
end
