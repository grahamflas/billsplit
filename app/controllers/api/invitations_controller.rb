class Api::InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def accept
    Invitations::Accept.new(
      invitation:,
    ).process
  end

  private

  def authorize_user
    unless invitation&.invitee  === current_user
      head :unauthorized
    end
  end

  def invitation
    @invitation ||= Invitation.find_by(id: params[:id])
  end
end
