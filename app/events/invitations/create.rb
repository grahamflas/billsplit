module Invitations
  class Create
    class InvitationAlreadyExistsError < StandardError; end

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
      begin
        @invitation = create_invitation

        if invitee
          notify
        else
          InvitationMailer.with(
            creator:,
            invitee_email:,
            group:,
          ).invitation_for_non_user_email.deliver_now
        end

        @invitation
      rescue ActiveRecord::RecordNotUnique
        InvitationAlreadyExistsError.new("#{invitee_email} has already been invited to join")
      end
    end

    private

    attr_reader :creator, :invitee_email, :group

    def create_invitation
      Invitation.create!(
        creator:,
        invitee:,
        invitee_email:,
        group:,
        status: :pending,
      )
    end

    def invitee
      @invitee ||= User.find_by(email: invitee_email)
    end

    def notify
      Notification.create!(
        user: invitee,
        source: @invitation,
        category: :invitation_created,
      )
    end
  end
end
