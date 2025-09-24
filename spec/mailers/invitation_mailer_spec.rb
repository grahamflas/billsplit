require "rails_helper"

RSpec.describe InvitationMailer, type: :mailer do
  describe "invitation_for_non_user_email" do
    let(:group) { create(:group) }
    let(:creator) { create(:user, groups: [ group ]) }
    let(:invitee_email) { "not-a-user-yet@mail.com" }
    let(:mail) do
      InvitationMailer.with(
        creator:,
        invitee_email:,
        group:,
      ).invitation_for_non_user_email
    end

    it "renders the headers" do
      expect(mail.subject).to eq("You've been invited to join BillSplit!")
      expect(mail.to).to eq([invitee_email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi!")
      expect(mail.body.encoded).to match(
        "You've been invited by #{creator.full_name} to join the group #{group.name} on BillSplit",
      )
    end
  end
end
