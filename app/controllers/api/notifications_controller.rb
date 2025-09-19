class Api::NotificationsController < Api::BaseController
  before_action :authenticate_user!
  before_action :authorize_user

  def destroy
    notification&.destroy!

    head :ok
  end

  private

  def authorize_user
    unless notification.user === current_user
      head :unauthorized
    end
  end

  def notification
    @notification ||= Notification.find_by(id: params[:id])
  end
end
