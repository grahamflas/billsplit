class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :addable_users, only: %i[new edit]

  def show
    @group = Group.find_by(id: params[:id])

    if @group
      @balances = Balances.new(group: @group).compute
      @settlements = @group.settlements
      @pending_invitations = @group.invitations.pending
    else
      redirect_to root_path
    end

  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find_by(id: params[:id])
  end

  private

  def addable_users
    @addable_users = User.
      joins(:groups).
      merge(current_user.groups).
      distinct
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
