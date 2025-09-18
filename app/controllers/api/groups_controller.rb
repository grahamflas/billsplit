class Api::GroupsController < ApplicationController
  before_action :authenticate_user!

  def create
    group = Group.new(group_params)

    if group.save
      current_user.groups << group

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
      group.users << current_user

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

  def group_params
    params.
      require(:group).
      permit(
        :name,
        user_ids: [],
      )
  end
end
