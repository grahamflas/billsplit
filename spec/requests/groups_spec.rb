require 'rails_helper'

RSpec.describe "Groups", type: :request do
  describe "GET /show" do
    it "returns http success" do
      user = create(:user)
      sign_in user

      group = create(:group)
      get group_path(group)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      user = create(:user)
      sign_in user

      get new_group_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      user = create(:user)
      sign_in user

      post groups_path, params: {
        group: {
          name: "My Group"
        }
      }

      expect(response).to redirect_to(group_path(Group.last))
    end
  end
end
