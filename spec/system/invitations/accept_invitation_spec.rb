require "rails_helper"

RSpec.describe "Accept invitation", type: :system, js: true do
  scenario "invitee accepts invitation, gets redirected to the group page, group users get notified that invitee has joined", :aggregate_failures do
    group = create(:group)
    creator = create(:user, groups: [ group ])
    other_group_member = create(:user, groups: [ group ])
    invitee = create(:user)

    invitation = Invitations::Create.new(
      creator:,
      invitee_email: invitee.email,
      group:,
    ).process

    sign_in(invitee)

    visit root_path

    notifications_button = find("[data-test='notifications-button']")

    within notifications_button do
      expect(page).to have_content("Notifications")
      expect(page).to have_content("1")
    end

    notifications_button.click

    notifications_dropdown = find("[data-test='notifications-dropdown']")

    within notifications_dropdown do
      expect(page).to have_content("#{creator.first_name} invited you to join #{group.name}")
    end

    click_button("Accept")

    expect(invitation.reload.accepted?).to eq(true)

    expect(page).to have_content(group.name)
    expect(page).to have_content("Total Expenses")

    expect(group.reload.users).to include(invitee)
  end
end
