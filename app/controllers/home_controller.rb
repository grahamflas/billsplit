class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = current_user.
      groups.
      includes(:users).
      includes(:expenses).
      active.
      to_api.
      serializable_hash
  end
end
