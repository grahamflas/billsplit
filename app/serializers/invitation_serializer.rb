class InvitationSerializer < ApplicationSerializer
  belongs_to :creator
  belongs_to :group
  belongs_to :invitee

  attribute :invitee_email
end
