require 'rails_helper'

RSpec.describe "Api::Notifications", type: :request do
  describe "DELETE /api/notifications/:id" do
    it "destroys the notification and responds with OK" do
      group = create(:group)
      expense_creator = create(:user, groups: [ group ])
      notification_recipient = create(:user, groups: [ group ])
      expense = create(
        :expense,
        group:,
        user: expense_creator
      )

      sign_in(notification_recipient)

      notification = create(
        :notification,
        category: :expense_added,
        source: expense,
        user: notification_recipient
      )

      delete api_notification_path(notification)

      expect(Notification.find_by(id: notification.id)).not_to be_present

      expect(response).to have_http_status(:ok)
    end
  end
end
