class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def update
    if user&.update(user_params)
      head :ok
    else
      head :unprocessable_content
    end
  end

  private

  def user_params
    params.
      require(:user).
      permit(
        :has_seen_demo_modal,
      )
  end

  def authorize_user
    unless user  === current_user
      head :unauthorized
    end
  end

  def user
    @user ||= User.find_by(id: params[:id])
  end
end
