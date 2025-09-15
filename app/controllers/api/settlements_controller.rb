class Api::SettlementsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def create
    create_settlement = ::Settlements::Create.new(
      balances: Balances.new(group:).compute,
      initiator: user,
      group:,
      note: settlement_params[:note]
    )

    if create_settlement.process
      flash[:success] = "Settled expenses for: #{group.name}"

      render json: 'Settlement created', status: :ok
    else
      flash[:error] = "Something went wrong"

      render json: { error: "error" }, status: :unprocessable_content
    end
  end

  private

  def authorize_user
    unless current_user.groups.include?(group)
      head :unauthorized
    end
  end

  def group
    @group ||= Group.find_by(id: settlement_params[:group_id])
  end

  def user
    User.find_by(id: settlement_params[:user_id])
  end

  def settlement_params
    params.
      require(:settlement).
      permit(
        :group_id,
        :note,
        :user_id,
      )
  end
end
