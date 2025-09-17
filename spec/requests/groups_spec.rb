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

  describe "GET /edit" do
    it "returns http success" do
      group = create(:group)
      user = create(:user, groups: [ group ])
      sign_in user

      get edit_group_path(group)
      expect(response).to have_http_status(:success)
    end
  end
end
