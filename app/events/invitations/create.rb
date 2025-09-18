module Invitations
  class Create
    def initialize(
      creator:,
      invitee_email:,
      group:
    )
      @creator = creator
      @invitee_email = invitee_email
      @group = group
    end

    def process
      Invitation.create!(
        creator:,
        invitee:,
        invitee_email:,
        group:,
        status: :pending,
      )
    end

    private

    attr_reader :creator, :invitee_email, :group

    def invitee
      User.find_by(email: invitee_email)
    end
  end
end
