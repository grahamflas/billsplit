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
    expect(page).to have_current_path(archived_groups_path)
  end

  scenario "it notifies all group members" do
    group = create(:group, name: "Roomies")
    user = create(:user, groups: [ group ])
    other_user_1 = create(:user, groups: [ group ])
    other_user_2 = create(:user, groups: [ group ])

    sign_in user

    visit group_path(group)

    edit_link = find("a[aria-label='Edit #{group.name}']")
    edit_link.click

    click_button("Archive Roomies")
    click_button "archive"

    expect(
      user.notifications.group_archived.where(source: group)
    ).to be_present

    expect(
      other_user_1.notifications.group_archived.where(source: group)
    ).to be_present
    expect(
      other_user_2.notifications.group_archived.where(source: group)
    ).to be_present

    click_button("Notifications")

    within "[data-test='notifications-dropdown']" do
      click_link("#{group.reload.name} was archived on #{group.archived_on.strftime("%-d %b %Y")}")
    end

    expect(page).to have_current_path(group_path(group))
  end

  context "when a group has open expenses" do
    scenario "user is directed to settle expenses before archiving" do
      group = create(:group)

      user_1 = create(:user, groups: [ group ])
      user_2 = create(:user, groups: [ group ])

      expense_1 = create(
        :expense,
        user: user_1,
        group:,
      )
      expense_2 = create(
        :expense,
        user: user_1,
        group:,
      )

      sign_in user_1

      visit group_path(group)

      edit_link = find("a[aria-label='Edit #{group.name}']")
      edit_link.click

      visit edit_group_path(group)

      click_button("Archive #{group.name}")

      within "#archive-group-modal" do
        expect(page).to have_content("#{group.name} still has open expenses")
        expect(page).to have_link("Back to #{group.name}", href: group_path(group))
      end
    end
  end
end
