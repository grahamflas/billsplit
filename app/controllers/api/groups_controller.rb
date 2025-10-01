class Api::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, only: :update
  before_action :verify_current_user_is_in_group, only: :create

  def create
    new_group = Group.new(group_params)

    if new_group.save
      create_invitations(group: new_group)

      flash[:success] = "#{new_group.name} created"

      render json: {
        errors: nil,
        group: new_group.reload.to_api.serializable_hash
      }
    else
      render json: {
        group: nil,
        errors: new_group.errors.full_messages,
      }, status: :unprocessable_content
    end
  end

  def update
    if group.update(group_params)
      if new_contacts.any?
        create_invitations(group:)
      end

      flash[:success] = "Updated #{group.name}"

      render json: {
        errors: nil,
        group: group.reload.to_api.serializable_hash
      }
    else
      render json: {
        errors: group.errors.full_messages,
        group: nil,
      }
    end
  end

  private

  def group
    @group = Group.find_by(id: params[:id])
  end

  def authorize_user
    unless group.users.include?(current_user)
      head :unauthorized
    end
  end

  def verify_current_user_is_in_group
    unless group_params[:user_ids].map(&:to_i).include?(current_user.id)
      render json: {
        group: nil,
        errors: ["You must add yourself to the group"],
      }, status: :unprocessable_content
    end
  end

  def new_contacts
    params[:new_contacts].reject(&:blank?)
  end

  def create_invitations(group:)
    new_contacts.map do |invitee_email|
      result = Invitations::Create.new(
        creator: current_user,
        invitee_email:,
        group:,
      ).process

      if result.is_a?(Invitations::Create::InvitationAlreadyExistsError)
        if flash[:error]
          flash[:error] << result.message
        else
          flash[:error] = Array.wrap(result.message)
        end
      end
    end
  end

  def group_params
    params.
      require(:group).
      permit(
        :name,
        user_ids: [],
      )
  end
end
