require 'rails_helper'

RSpec.describe "Groups", type: :request do
  describe "GET /groups/:id" do
    context "when the user is a member of the group" do
      it "returns http success" do
        group = create(:group)

        user = create(:user, groups: [ group ])

        sign_in user

        get group_path(group)
        expect(response).to have_http_status(:success)
      end
    end

    context "when the user is not a member of the group" do
      it "redirects to the home page and flashes an error" do
        group = create(:group)
        other_group = create(:group)

        user = create(:user, groups: [ group ])
        _other_user = create(:user, groups: [ other_group ])

        sign_in user

        get group_path(other_group)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("Unauthorized")
      end
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
