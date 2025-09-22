require "rails_helper"

describe Invitations::LinkPendingInvitations do
  it "links invitations with new users" do
    group_1 = create(:group, name: "Group 1")
    group_2 = create(:group, name: "Group 2")

    group_1_creator = create(:user, groups: [ group_1 ])
    group_2_creator = create(:user, groups: [ group_2 ])

    new_user = create(:user, email: "no_account_yet@mail.com")
    existing_user = create(:user)

    group_1_invitation = create(
      :invitation,
      group: group_1,
      creator: group_1_creator,
      invitee: nil,
      invitee_email: "no_account_yet@mail.com"
    )
    group_2_invitation = create(
      :invitation,
      group: group_2,
      creator: group_2_creator,
      invitee: nil,
      invitee_email: "no_account_yet@mail.com"
    )

    group_1_invitation_existing_user = create(
      :invitation,
      group: group_1,
      creator: group_1_creator,
      invitee: existing_user,
      invitee_email: existing_user.email,
    )

    Invitations::LinkPendingInvitations.new(
      new_user:,
    ).process

    expect(group_1_invitation.reload.invitee).to eq(new_user)
    expect(group_2_invitation.reload.invitee).to eq(new_user)

    expect(group_1_invitation_existing_user.reload.invitee).to eq(existing_user)
  end

  it "creates a notification for the new user" do
    group_1 = create(:group)
    group_2 = create(:group)

    creator_1 = create(:user, groups: [ group_1 ])
    creator_2 = create(:user, groups: [ group_2 ])

    new_user = create(:user, email: "no_account_yet@mail.com")

    invitation_1 = create(
      :invitation,
      group: group_1,
      creator: creator_1,
      invitee: nil,
      invitee_email: "no_account_yet@mail.com"
    )

    invitation_2 = create(
      :invitation,
      group: group_2,
      creator: creator_2,
      invitee: nil,
      invitee_email: "no_account_yet@mail.com"
    )

    Invitations::LinkPendingInvitations.new(
      new_user:,
    ).process

    expect(invitation_1.reload.invitee).to eq(new_user)
    expect(invitation_2.reload.invitee).to eq(new_user)

    expect(
      Notification.
        invitation_created.
        find_by(
          source: invitation_1,
          user: new_user,
        ),
    ).to be_present

    expect(
      Notification.
        invitation_created.
        find_by(
          source: invitation_2,
          user: new_user,
        ),
    ).to be_present
  end

  context "when there are no invitations for the new user" do
    it "no-ops" do
      group = create(:group)

      creator = create(:user, groups: [ group ])

      new_user = create(:user)
      other_user = create(:user)

      other_user_invitation = create(
        :invitation,
        group:,
        creator:,
        invitee: other_user,
        invitee_email: other_user.email,
      )

      result = Invitations::LinkPendingInvitations.new(
        new_user:,
      ).process

      expect(result).to eq(nil)

      expect(other_user_invitation.reload.invitee).to eq(other_user)
    end
  end
end
