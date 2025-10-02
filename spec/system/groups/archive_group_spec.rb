require "rails_helper"

RSpec.describe "Archive Group", type: :system, js: true do
  scenario "user can archive a group" do
    group = create(:group, name: "Roomies")
    user = create(:user, groups: [ group ])

    sign_in user

    visit group_path(group)

    edit_link = find("a[aria-label='Edit #{group.name}']")
    edit_link.click

    click_button("Archive Roomies")

    within "#archive-group-modal" do
      expect(page).to have_content("Are you sure?")
      expect(page).to have_content("You're about to archive this group for you and all other members")
      expect(page).to have_button("cancel")
      expect(page).to have_button("archive")

      click_button "cancel"
    end

    expect(page).not_to have_selector("#archive-group-modal")

    click_button("Archive Roomies")
    click_button "archive"

    expect(group.reload.archived?).to eq(true)
    expect(page).to have_current_path(root_path)
  end
end
