require "rails_helper"

RSpec.describe "Group Management", type: :system, js: true do
  scenario "User can create a group" do
    user = create(:user)
    sign_in user

    visit new_group_path

    name = "Berlin trip"

    fill_in "Group name", with: name

    expect do
      click_button "Create Group"
    end.to change(Group, :count).by(1)

    group = Group.find_by(name:)

    expect(user.groups).to include(group)

    expect(page).to have_content(name)
  end

  context "when the user doesn't provide a group name" do
    scenario "it rerenders the form with errors" do
      user = create(:user)
      sign_in user

      visit new_group_path

      expect do
        click_button "Create Group"
      end.not_to change(Group, :count)

      expect(page).to have_content("1 error prohibited this group from being saved")
      expect(page).to have_content("Name can't be blank")

      fill_in "Group name", with: ""

      expect do
        click_button "Create Group"
      end.not_to change(Group, :count)

      expect(page).to have_content("1 error prohibited this group from being saved")
      expect(page).to have_content("Name can't be blank")
    end
  end

  scenario "user can add one or multiple users to the group at creation time" do
    user = create(:user)
    other_user_1 = create(:user)
    other_user_2 = create(:user)

    sign_in user

    visit new_group_path

    within "select#group_user_ids" do
      expect(page).not_to have_content(user.email)

      expect(page).to have_content(other_user_1.email)
      expect(page).to have_content(other_user_2.email)
    end

    # Create a group with 1 additional user
    group_1_name = "Group with 1 other user"
    fill_in "Group name", with: group_1_name
    select other_user_1.email
    click_button "Create Group"

    expect(page).to have_content(group_1_name)

    group_1 = Group.find_by(name: group_1_name)
    expect(group_1.users).to include(
      user,
      other_user_1,
    )

    visit new_group_path

    # Create a group with 2 additional users
    group_2_name = "Group with 2 other users"
    fill_in "Group name", with: group_2_name
    select other_user_1.email
    select other_user_2.email
    click_button "Create Group"

    expect(page).to have_content(group_2_name)

    group_2 = Group.find_by(name: group_2_name)
    expect(group_2.users).to include(
      user,
      other_user_1,
      other_user_2,
    )
  end
end
