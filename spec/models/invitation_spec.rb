require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe "#accept" do
    it "adds the invitee to the group, changes the invitation's status to :accepted" do
      group = create(:group)
      creator = create(:user, groups: [ group ])
      invitee = create(:user)

      invitation = create(
        :invitation,
        group:,
        creator:,
        invitee:,
        invitee_email: invitee.email,
        status: "pending",
      )

      expect(group.users).not_to include(invitee)

      invitation.accept

      expect(invitation.reload.status).to eq("accepted")
      expect(group.reload.users).to include(invitee)
    end

    context "if the invitee does not exist" do
      it "no-ops" do
        group = create(:group)
        creator = create(:user, groups: [ group ])

        invitation = create(
          :invitation,
          group:,
          creator:,
          invitee: nil,
          invitee_email: "user-does-not-exist-yet@mail.com",
          status: "pending",
        )

        original_group_users = invitation.group.users

        invitation.accept

        expect(invitation.reload.status).to eq("pending")
        expect(group.reload.users).to eq(original_group_users)
      end
    end
  end

  describe "#decline" do
    it "does not add the invitee to the group, changes the invitation's status to :declined" do
      group = create(:group)
      creator = create(:user, groups: [ group ])
      invitee = create(:user)

      invitation = create(
        :invitation,
        group:,
        creator:,
        invitee:,
        invitee_email: invitee.email,
        status: "pending",
      )

      expect(group.users).not_to include(invitee)

      invitation.decline

      expect(invitation.reload.status).to eq("declined")
      expect(group.reload.users).not_to include(invitee)
    end

    context "if the invitee does not exist" do
      it "no-ops" do
        group = create(:group)
        creator = create(:user, groups: [ group ])

        invitation = create(
          :invitation,
          group:,
          creator:,
          invitee: nil,
          invitee_email: "user-does-not-exist-yet@mail.com",
          status: "pending",
        )

        original_group_users = invitation.group.users

        invitation.decline

        expect(invitation.reload.status).to eq("pending")
        expect(group.reload.users).to eq(original_group_users)
      end
    end
  end
end
