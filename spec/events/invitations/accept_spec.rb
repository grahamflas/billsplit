require "rails_helper"

describe Invitations::Accept do
  it "accepts the invitation, deletes the invitee's invitation notification, notifies group's other users of the accepted invite" do
    group = create(:group)
    inviter = create(:user, groups: [ group ])
    other_group_member = create(:user, groups: [ group ])
    invitee = create(:user)

    invitation = Invitations::Create.new(
      creator: inviter,
      invitee_email: invitee.email,
      group:,
    ).process

    Invitations::Accept.new(
      invitation_id: invitation.id
    ).process

    expect(invitation.reload.status).to eq("accepted")

    expect(
      Notification.
        invitation_created.
        find_by(
          user: invitee,
          source: invitation,
          category: :invitation_created,
        )
    ).not_to be_present

    expect(group.users).to match_array(
      [
        inviter,
        other_group_member,
        invitee,
      ],
    )

    expect(
      Notification.
        member_added_to_group.
        find_by(
          user: inviter,
          source: invitation,
        ),
    ).to be_present

    expect(
      Notification.
        member_added_to_group.
        find_by(
          user: other_group_member,
          source: invitation,
        ),
    ).to be_present

    # don't notify the user who accepted the invite
    expect(
      Notification.
        member_added_to_group.
        find_by(
          user: invitee,
          source: invitation,
        ),
    ).not_to be_present
  end

  context "when the invite has already been accepted" do
    it "noops" do
      group = create(:group)
      inviter = create(:user, groups: [ group ])
      other_group_member = create(:user, groups: [ group ])
      invitee = create(:user)

      invitation = Invitations::Create.new(
        creator: inviter,
        invitee_email: invitee.email,
        group:,
      ).process

      Invitations::Accept.new(
        invitation_id: invitation.id
      ).process

      second_invocation = Invitations::Accept.new(
        invitation_id: invitation.id
      ).process

      expect(second_invocation).to be_nil
    end
  end
end
