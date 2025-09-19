require 'rails_helper'

RSpec.describe "Api::Invitations", type: :request do
  describe "PUT /api/invitations/:id/accept" do
    it "accepts the invitation and returns OK" do
      group = create(:group)
      inviter = create(:user, groups: [ group ])
      invitee = create(:user)

      sign_in(invitee)

      invitation = Invitations::Create.new(
        creator: inviter,
        invitee_email: invitee.email,
        group:,
      ).process

      put accept_api_invitation_path(invitation)

      expect(invitation.reload.status).to eq("accepted")
    end

    it "only allows invitee to accept the invite" do
      group = create(:group)
      inviter = create(:user, groups: [ group ])
      invitee = create(:user)
      unauthorized = create(:user, groups: [ group ])

      sign_in(unauthorized)

      invitation = Invitations::Create.new(
        creator: inviter,
        invitee_email: invitee.email,
        group:,
      ).process

      put accept_api_invitation_path(invitation)

      expect(invitation.reload.status).to eq("pending")

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
