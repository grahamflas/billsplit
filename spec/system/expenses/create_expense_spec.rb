require "rails_helper"

RSpec.describe "Create Expense", type: :system, js: true do
  describe "when creating an expense through a group page" do
    scenario "user can create an expense, group name is pre-filled and user select includes only group members" do
      other_group = create(:group, name: "Other Group")
      group = create(:group, name: "Group")

      user_1 = create(:user, groups: [ group, other_group ])
      user_2 = create(:user, groups: [ group ])
      other_user = create(
        :user,
        email: "other_user@mail.com",
        groups: [ other_group ],
      )

      sign_in user_1

      visit group_path(group)

      click_link "+ Add Expense"

      expect(page).to have_select("Group", selected: group.name)

      expect(page).to have_select(
        "Paid by",
        with_options: [
          user_1.full_name,
          user_2.full_name,
        ],
      )
      expect(page).not_to have_select(
        "Paid by",
        with_options: [ other_user.full_name ]
      )

      fill_in "Reference", with: "My new expense"
      fill_in "Amount", with: 50

      click_button "Create Expense"

      expect(page).to have_content("Added My new expense")
    end
  end

  describe "when creating an expense directly (not through the group page)" do
    describe "creating an expense" do
      scenario "user can create a new expense" do
        group_1 = create(:group, name: "Group 1")
        group_2 = create(:group, name: "Group 2")

        user_1 = create(
          :user,
          groups: [ group_1, group_2 ]
        )
        user_2 = create(
          :user,
          groups: [ group_1, group_2 ]
        )

        sign_in user_1

        visit new_expense_path

        expect(page).to have_content("New Expense")

        fill_in "Reference", with: "My new expense"
        fill_in "Amount", with: 20
        select group_2.name
        select user_2.full_name

        expect do
          click_button "Create Expense"
        end.to change(Expense, :count).by(1)

        expense = Expense.last

        # [TODO] bring back after toastr is implemented
        # expect(page).to have_content("Added expense: #{expense.reference}")

        within "#expense-#{expense.id}" do
          expect(page).to have_content(expense.amount)
          expect(page).to have_content("Paid by #{user_2.first_name} #{user_2.last_name}")
        end
      end
    end

    describe "Group select" do
      scenario "only includes groups of which the current_user is a member" do
        group_1 = create(:group, name: "Group 1")
        group_2 = create(:group, name: "Group 2")
        other_group = create(:group, name: "Other group")

        user = create(
          :user,
          groups: [ group_1, group_2 ]
        )

        sign_in user

        visit new_expense_path

        expect(page).to have_select(
          "Group",
          with_options: [ group_1.name, group_2.name ],
        )
        expect(page).not_to have_select(
          "Group",
          with_options: [ other_group.name ]
        )
      end
    end

    describe "User select" do
      scenario "only includes users for the selected group " do
        group_1 = create(:group)
        group_2 = create(:group)
        other_group = create(:group)

        user_1 = create(
          :user,
          groups: [ group_1, group_2 ],
        )
        user_2 = create(
          :user,
          groups: [ group_1 ],
        )
        user_3 = create(
          :user,
          groups: [ group_2 ],
        )
        other_user = create(
          :user,
          email: "otheruser@email.com",
          groups: [ other_group ]
        )

        sign_in user_1

        visit new_expense_path

        expect(page).to have_select(
          "Paid by",
          selected: user_1.full_name,
          with_options: [
            user_1.full_name,
            user_2.full_name,
          ],
        )
        expect(page).not_to have_select(
          "Paid by",
          with_options: [ user_3.full_name ]
        )
        expect(page).not_to have_select(
          "Paid by",
          with_options: [ other_user.full_name ]
        )

        select group_2.name

        expect(page).to have_select(
          "Paid by",
          selected: user_1.full_name,
          with_options: [
            user_1.full_name,
            user_3.full_name,
          ],
        )
        expect(page).not_to have_select(
          "Paid by",
          with_options: [ user_2.full_name ]
        )
      end
    end
  end
end
