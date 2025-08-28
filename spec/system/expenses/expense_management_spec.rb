require "rails_helper"

RSpec.describe "Expense Management", type: :system, js: true do
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
        "User",
        with_options: [
          user_1.email,
          user_2.email,
        ],
      )
      expect(page).not_to have_select(
        "User",
        with_options: [ other_user.email ]
      )
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
        select user_2.email

        expect do
          click_button "Create Expense"
        end.to change(Expense, :count).by(1)

        expense = Expense.last

        expect(page).to have_content("Added expense: #{expense.reference}")

        within "#expense-#{expense.id}" do
          expect(page).to have_content(expense.amount)
          expect(page).to have_content("Paid by: #{user_2.email}")
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
      scenario "only includes users in the groups that the current_user is a member of" do
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
          "User",
          with_options: [
            user_1.email,
            user_2.email,
            user_3.email ,
          ],
        )
        expect(page).not_to have_select(
          "User",
          with_options: [ other_user.email ]
        )
      end
    end

    context "when the user selects a user that is not in the selected group" do
      scenario "re-renders the form with an error" do
        group = create(:group, name: "Group")
        other_group = create(:group, name: "Other Group")

        user_1 = create(
          :user,
          email: "user_1@mail.com",
          groups: [ group, other_group ]
        )
        _user_2 = create(
          :user,
          email: "user_2@mail.com",
          groups: [ group, other_group ]
        )
        user_3 = create(
          :user,
          email: "user_3@mail.com",
          groups: [ group ]
        )

        sign_in user_1

        visit new_expense_path

        fill_in "Reference", with: "Expense 1"
        fill_in "Amount", with: 5

        select "Other Group"
        select user_3.email

        expect do
          click_button "Create Expense"
        end.not_to change(Expense, :count)

        expect(page).to have_content(Expense::MUST_BELONG_TO_SELECTED_GROUP_ERROR)
      end
    end
  end
end
