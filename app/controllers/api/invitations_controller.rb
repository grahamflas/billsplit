class Api::InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def accept
    Invitations::Accept.new(
      invitation:,
    ).process

    head :ok
  end

  def decline
    Invitations::Decline.new(
      invitation:,
    ).process

    head :ok
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
