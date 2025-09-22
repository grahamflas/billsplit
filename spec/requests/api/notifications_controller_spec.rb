require 'rails_helper'

RSpec.describe "Api::Notifications", type: :request do
  describe "GET /api/notifications" do
    it "returns notifications for the current_user as JSON" do
      group = create(:group)
      current_user = create(:user, groups: [ group ])
      other_user_in_group = create(:user, groups: [ group ])
      other_user_outside_group = create(:user)

      # current_user notifications
      added_expense = create(:expense, group:, user: current_user)
      expense_added_notification = create(
        :notification,
        user: current_user,
        source: added_expense,
        category: :expense_added,
      )

      updated_expense = create(:expense, group:, user: current_user)
      expense_updated_notification = create(
        :notification,
        user: current_user,
        source: updated_expense ,
        category: :expense_updated,
      )

      # other_user_in_group
      other_user_in_group_notification = create(
        :notification,
        user: other_user_in_group,
        source: create(:expense, group:),
        category: :expense_added,
      )

      # other_user_outside_group
      other_user_outside_group_notification = create(
        :notification,
        user: other_user_outside_group,
        source: create(:expense, group:),
        category: :expense_added,
      )

      sign_in current_user

      get api_notifications_path

      json_response = JSON.parse(response.body)

      expect(json_response["count"]).to eq(2)
      expect(json_response["notifications"]).to eq([
        {
          "category" => expense_added_notification.category,
          "id" => expense_added_notification.id,
          "link" => group_path(expense_added_notification.source.group),
          "source" => expense_added_notification.source.to_api.serializable_hash.deep_stringify_keys,
          "sourceType" => "Expense",
          "user" => current_user.to_api.serializable_hash.deep_stringify_keys
        },
        {
          "category" => expense_updated_notification.category,
          "id" => expense_updated_notification.id,
          "link" => group_path(expense_updated_notification.source.group),
          "source" => expense_updated_notification.source.to_api.serializable_hash.deep_stringify_keys,
          "sourceType" => "Expense",
          "user" => current_user.to_api.serializable_hash.deep_stringify_keys
        },
      ])

      expect(json_response["notifications"]).not_to include(
        a_hash_including(id: other_user_in_group_notification.id),
      )
      expect(json_response["notifications"]).not_to include(
        a_hash_including(id: other_user_outside_group_notification.id),
      )
    end
  end
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
