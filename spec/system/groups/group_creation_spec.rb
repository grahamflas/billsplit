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

      expect(page).to have_content("Name can't be blank")

      fill_in "Group name", with: ""

      expect do
        click_button "Create Group"
      end.not_to change(Group, :count)

      expect(page).to have_content("Name can't be blank")
    end
  end

  context "when the user already has groups with other members" do
    scenario "user can select from users who are already members of the user's existing groups and can add one or multiple users to the group at creation time" do
      group = create(:group)

      user = create(:user, groups: [ group ])
      other_user_1 = create(:user, groups: [ group ])
      other_user_2 = create(:user, groups: [ group ])
      other_user_3 = create(:user)

      sign_in user

      visit new_group_path

      group_members_select = find("#group-member-select")

      group_members_select.click

      expect(page).to have_content other_user_1.full_name
      expect(page).to have_content other_user_2.full_name
      expect(page).not_to have_content other_user_3.full_name

      # Create a group with 1 additional user
      group_1_name = "Group with 1 other user"

      fill_in "Group name", with: group_1_name

      within group_members_select do
        fill_in with: other_user_1.full_name

        group_members_select.send_keys(:enter)
      end

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

      within group_members_select do
        fill_in with: other_user_1.full_name
        group_members_select.send_keys(:enter)
      end

      within group_members_select do
        fill_in with: other_user_2.full_name
        group_members_select.send_keys(:enter)
      end

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

  context "when the user doesn't add themselves to the group" do
    it "flashes an error" do
      group = create(:group)

      user = create(:user, groups: [ group ])
      other_user = create(:user, groups: [ group ])

      sign_in user

      visit new_group_path

      fill_in "Group name", with: "My group"

      group_members_select = find("#group-member-select")

      within group_members_select do
        fill_in with: other_user.full_name

        group_members_select.send_keys(:enter)
      end

      remove_user(user)

      expect do
        click_button "Create Group"
      end.not_to change(Group, :count)

      expect(page).to have_content("You must add yourself to the group")
    end
  end

  scenario "can invite new contacts (people not in any existing groups) via email, displays pending invitations on group page" do
    user = create(:user)
    other_user = create(:user)

    sign_in user

    visit new_group_path

    fill_in "Group name", with: "My group"

    click_button "Invite new contact"

    fill_in "newContacts.0", with: "newContact0@email.com"

    click_button "Invite new contact"

    fill_in "newContacts.1", with: "newContact1@email.com"

    find("button[aria-label='Remove New Contact 1']").click

    expect(page).not_to have_field("newContacts.1")

    click_button "Invite new contact"

    fill_in "newContacts.1", with: other_user.email

    expect do
      click_button "Create Group"
    end.to change(Invitation, :count).by(2)

    # [TODO] test email sent
    group = Group.find_by(name: "My group")

    expect(page).to have_current_path(group_path(group))

    click_button("Pending invitations")

    expect(page).to have_content("#{user.first_name} invited newContact0@email.com to join")
    expect(page).to have_content("#{user.first_name} invited #{other_user.full_name} to join")
  end



  def remove_user(user)
    find("div [aria-label='Remove #{user.full_name}']").click
  end
end
