class Api::SettlementsController < ApplicationController
  before_action :authenticate_user!

  def create
    render json: 'success', status: :ok
  end
end
