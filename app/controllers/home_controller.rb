class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = current_user.groups
    @user_name = "Graham"
    @location = "Berlin"
  end
end
