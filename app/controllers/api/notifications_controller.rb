class Api::NotificationsController < Api::BaseController
  before_action :authenticate_user!
  before_action :authorize_user, only: :destroy

  def index
    render json: {
      count: notifications.count,
      notifications: notifications&.to_api.serializable_hash,
    }
  end

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

  def notifications
    @notifications ||= current_user.notifications
  end
end
