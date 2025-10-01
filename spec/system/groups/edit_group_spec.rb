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

  scenario "can invite new contacts (people not in any existing groups) via email" do
    group = create(:group)
    user = create(:user, groups: [ group ])

    sign_in user

    visit group_path(group)

    find("a[aria-label='Edit #{group.name}']").click

    fill_in "Group name", with: "Edited Group Name"

    click_button "Invite new contact"

    fill_in "newContacts.0", with: "newContact0@email.com"

    click_button "Invite new contact"

    fill_in "newContacts.1", with: "newContact1@email.com"

    find("button[aria-label='Remove New Contact 1']").click

    expect(page).not_to have_field("newContacts.1")

    expect do
      click_button "Update group"
    end.to change(Invitation, :count).by(1)
  end

  context "when a pending invitation already exists for the email" do
    scenario "it flashes an error" do
      group = create(:group)
      user = create(:user, groups: [ group ])
      other_user = create(:user, groups: [ group ])

      new_contact_email = "new_contact@email.com"
      other_new_contact_email = "other_new_contact@email.com"

      sign_in user

      visit group_path(group)

      find("a[aria-label='Edit #{group.name}']").click

      fill_in "Group name", with: "Edited Group Name"

      # Invite new contacts the first time
      click_button "Invite new contact"

      fill_in "newContacts.0", with: new_contact_email

      click_button "Invite new contact"

      fill_in "newContacts.1", with: other_new_contact_email

      click_button "Update group"

      sign_out user

      # Sign in as other group user and invite the same people
      sign_in other_user

      visit group_path(group.reload)

      find("a[aria-label='Edit #{group.name}']").click

      # Invite new contacts again
      click_button "Invite new contact"

      fill_in "newContacts.0", with: new_contact_email

      click_button "Invite new contact"

      fill_in "newContacts.1", with: other_new_contact_email

      expect do
        click_button "Update group"
      end.not_to change(Invitation, :count)

      expect(page).to have_current_path(group_path(group))

      expect(page).to have_content("#{new_contact_email} has already been invited to join")
      expect(page).to have_content("#{other_new_contact_email} has already been invited to join")
    end
  end

  def remove_user(user)
    find("div [aria-label='Remove #{user.full_name}']").click
  end
end
