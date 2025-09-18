require "rails_helper"

describe Settlements::Create do
  it "creates a pending invitation" do
    group = create(:group)
    user = create(:user, groups: [ group ])
    invitee = create(:user, email: "invitee@email.com")

    invitation = Invitations::Create.new(
      creator: user,
      invitee_email: invitee.email,
      group:,
    ).process

    expect(invitation).to have_attributes({
      group_id: group.id,
      creator_id: user.id,
      invitee_id: invitee.id,
      invitee_email: "invitee@email.com",
      status: "pending",
    })
  end

  context "when there is no user with the invitee email" do
    it "creates the invitation with invitee_id of nil" do
      group = create(:group)
      user = create(:user, groups: [ group ])

      invitation = Invitations::Create.new(
        creator: user,
        invitee_email: "does-not-exist-yet@mail.com",
        group:,
      ).process

      expect(invitation).to have_attributes({
        group_id: group.id,
        creator_id: user.id,
        invitee_id: nil,
        invitee_email: "does-not-exist-yet@mail.com",
        status: "pending",
      })
    end
  end
end
