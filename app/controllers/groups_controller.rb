class GroupsController < ApplicationController
  before_action :authenticate_user!

  def show
    @group = Group.find_by(id: params[:id])

    if @group
      @balances = Balances.new(group: @group).compute
      @settlements = @group.settlements
    else
      redirect_to root_path
    end

  end

  def new
    @group = Group.new
    @addable_users = User.
      joins(:groups).
      merge(current_user.groups).
      where.not(id: current_user.id).
      distinct
  end

  def edit
    @group = Group.find_by(id: params[:id])
    @addable_users = User.
      joins(:groups).
      merge(current_user.groups).
      where.not(id: current_user.id).
      distinct
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
