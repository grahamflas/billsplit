require 'rails_helper'

RSpec.describe "Api::Groups", type: :request do
  describe "POST /groups" do
    it "creates a group and responds with an OK status and the group" do
      user = create(:user)
      other_user_1 = create(:user)
      other_user_2 = create(:user)

      sign_in user

      expect do
        post api_groups_path, params: {
          group: {
            name: "Berlin trip group",
            user_ids: [other_user_1.id, other_user_2.id],
          }
        }
      end.to change(Group, :count).by(1)

      expect(response).to have_http_status(:success)
      expect(response.parsed_body["group"]["name"]).to eq("Berlin trip group")
    end

    context "with missing params" do
      it "responds with unprocessable entity and error messages" do
        user = create(:user)

        sign_in user

        expect do
          post api_groups_path, params: {
            group: {
              name: "",
              user_ids: [],
            }
          }
        end.not_to change(Group, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["errors"]).to eq(["Name can't be blank"])
      end
    end
  end

end
