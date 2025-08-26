class GroupsController < ApplicationController
  before_action :authenticate_user!

  def show
    @group = Group.find_by(id: params[:id])

    unless @group
      redirect_to root_path
    end
  end

  def new
    @group = Group.new
    @addable_users = User.where.not(id: current_user)
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      current_user.groups << @group

      flash[:success] = "#{@group.name} created"

      redirect_to @group
    else
      render :new, status: :unprocessable_content
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
