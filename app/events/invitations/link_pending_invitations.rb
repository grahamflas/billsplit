module Invitations
  class LinkPendingInvitations
    def initialize(new_user:)
      @new_user = new_user
    end

    def process
      if new_user && pending_invitations_for_user.any?
        link_pending_invitations

        notify_new_user
      end
    end

    private

    attr_reader :new_user

    def pending_invitations_for_user
      @pending_invitations_for_user ||= Invitation.
        pending.
        where(
          invitee_email: new_user.email
        )
    end

    def link_pending_invitations
      pending_invitations_for_user.each do |invitation|
        invitation.update!(invitee: new_user)
      end
    end

    def notify_new_user
      pending_invitations_for_user.each do |invitation|
        Notification.create!(
          user: new_user,
          source: invitation,
          category: :invitation_created,
        )
      end
    end
  end
end
