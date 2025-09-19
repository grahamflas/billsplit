require "rails_helper"

describe Invitations::Decline do
  it "declines the invitation, deletes the invitee's invitation notification, notifies group's other users of the declined invite" do
    group = create(:group)
    inviter = create(:user, groups: [ group ])
    other_group_member = create(:user, groups: [ group ])
    invitee = create(:user)

    invitation = Invitations::Create.new(
      creator: inviter,
      invitee_email: invitee.email,
      group:,
    ).process

    Invitations::Decline.new(
      invitation:,
    ).process

    expect(invitation.reload.status).to eq("declined")

    expect(
      Notification.
        invitation_created.
        find_by(
          user: invitee,
          source: invitation,
          category: :invitation_created,
        )
    ).not_to be_present

    expect(group.users).not_to include(invitee)

    expect(
      Notification.
        invitation_declined.
        find_by(
          user: inviter,
          source: invitation,
        ),
    ).to be_present

    expect(
      Notification.
        invitation_declined.
        find_by(
          user: other_group_member,
          source: invitation,
        ),
    ).to be_present

    # don't notify the user who declined the invite
    expect(
      Notification.
        invitation_declined.
        find_by(
          user: invitee,
          source: invitation,
        ),
    ).not_to be_present
  end

  context "when the invite has already been declined" do
    it "no-ops" do
      group = create(:group)
      inviter = create(:user, groups: [ group ])
      other_group_member = create(:user, groups: [ group ])
      invitee = create(:user)

      invitation = Invitations::Create.new(
        creator: inviter,
        invitee_email: invitee.email,
        group:,
      ).process

      Invitations::Decline.new(
        invitation:,
      ).process

      second_invocation = Invitations::Decline.new(
        invitation:,
      ).process

      expect(second_invocation).to be_nil
    end
  end

  context "when the invitation doesn't exist" do
    it "no-ops" do
      result = Invitations::Decline.new(
        invitation: nil,
      ).process

      expect(result).to be_nil
    end
  end
end
