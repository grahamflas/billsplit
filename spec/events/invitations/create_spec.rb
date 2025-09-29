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

    expect(
      Notification.find_by(
        user: invitee,
        source: invitation,
        category: :invitation_created,
      ),
    ).to be_present
  end

  context "when there is no user with the invitee email" do
    it "creates the invitation with invitee_id of nil, does not create notification (defer this until user signs up)" do
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

      expect(invitation.notifications&.invitation_created).to be_empty
    end

    it "enqueues an email to the invitee notifying them of the invitation" do
      group = create(:group)
      creator = create(:user, groups: [ group ])

      invitee_email = "does-not-exist-yet@mail.com"

      expect do
        Invitations::Create.new(
          creator:,
          invitee_email:,
          group:,
        ).process
      end.to change { ActionMailer::Base.deliveries.count }.by(1)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include(invitee_email)

      # have_enqueued_mail(
      #   InvitationMailer,
      #   :invitation_for_non_user_email,
      # ).with(params: {creator:, invitee_email:, group:}, args: [])

    end
  end
end
