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
end
