require "rails_helper"

RSpec.describe "Edit Group", type: :system, js: true do
  scenario "user can edit group name and members" do
    group = create(:group)
    other_group = create(:group)

    user = create(:user, groups: [ group, other_group ])
    other_user_1 = create(:user, groups: [ group ])
    other_user_2 = create(:user, groups: [ group ])
    other_user_3 = create(:user, groups: [ other_group ])

    sign_in user

    visit group_path(group)

    edit_link = find("a[aria-label='Edit #{group.name}']")
    edit_link.click

    expect(page).to have_field("Group name", with: group.name)

    within "#group-member-select" do
      expect(page).to have_content(other_user_1.full_name)
      expect(page).to have_content(other_user_2.full_name)
    end

    fill_in "Group name", with: "Updated name"
    remove_user(other_user_1)

    click_button "Update group"

    expect(group.reload.name).to eq("Updated name")
    expect(group.users).not_to include(other_user_1)
  end

  def remove_user(user)
    find("div [aria-label='Remove #{user.full_name}']").click
  end
end
