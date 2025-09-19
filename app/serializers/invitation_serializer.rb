class InvitationSerializer < ApplicationSerializer
  belongs_to :creator
  belongs_to :group
  belongs_to :invitee

  attributes [:id, :invitee_email]
end
