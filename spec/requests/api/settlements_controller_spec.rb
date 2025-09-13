require 'rails_helper'

RSpec.describe "Api::Settlements", type: :request do
  describe "POST /create" do
    it "creates a settlement, returns http status :ok" do
      group = create(:group)
      user = create(:user, groups: [group])
      other_user = create(:user, groups: [group])
      create(:expense, amount: 10, user:, group:)
      create(:expense, amount: 20, user: other_user, group:)

      sign_in user

      post api_settlements_path, params: {
        settlement: {
          user_id: user.id,
          group_id: group.id,
          note: "New settlement",
        }
      }

      expect(Settlement.find_by(note: "New settlement")).not_to be_nil

      expect(response).to have_http_status(:ok)
    end

    context "when the current_user is not a member of the group being settled" do
      it "returns unauthorized" do
        group = create(:group)
        other_group = create(:group)

        user = create(:user, groups: [ group ])
        other_user = create(:user, groups: [ group ])
        unauthorized_user = create(:user, groups: [ other_group ])

        create(:expense, amount: 10, user:, group:)
        create(:expense, amount: 20, user: other_user, group:)

        sign_in unauthorized_user

        post api_settlements_path, params: {
          settlement: {
            user_id: user.id,
            group_id: group.id,
            note: "New settlement",
          }
        }

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end


