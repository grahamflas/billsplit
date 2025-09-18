class Api::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_current_user_is_in_group, only: :create

  def create
    group = Group.new(group_params)

    if group.save
      flash[:success] = "#{group.name} created"

      render json: {
        errors: nil,
        group: group.reload.to_api.serializable_hash
      }
    else
      render json: {
        group: nil,
        errors: group.errors.full_messages,
      }, status: :unprocessable_content
    end
  end

  def update
    group = Group.find_by(id: params[:id])

    if group.update(group_params)
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

  def verify_current_user_is_in_group
    unless group_params[:user_ids].include?(current_user.id)
      render json: {
        group: nil,
        errors: ["You must add yourself to the group"],
      }, status: :unprocessable_content
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
