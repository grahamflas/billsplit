require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    context "when the user is logged in" do
      it "returns http success" do
        user = create(:user)

        sign_in user

        get root_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when the user is not logged in" do
      it "redirects to the login page" do
        create(:user)

        get root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
