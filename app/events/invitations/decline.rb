module Invitations
  class Decline
    def initialize(invitation:)
      @invitation = invitation
    end

    def process
      if invitation&.pending?
        ApplicationRecord.transaction do
          invitation.decline

          destroy_invitee_notification

          notify_other_group_members
        end
      end
    end

    private

    attr_reader :invitation

    def destroy_invitee_notification
      Notification.
        invitation_created.
        find_by(
          user: invitation.invitee,
          source: invitation,
          category: :invitation_created,
        )&.destroy
    end

    def notify_other_group_members
      other_group_members.each do |user|
        Notification.create!(
          user:,
          source: invitation,
          category: :invitation_declined,
        )
      end
    end

    def other_group_members
      invitation.
        group.
        users.
        where.not(id: invitation.invitee)
    end
  end
end
