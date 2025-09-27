require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :request do
  describe "POST /users" do
    context "with valid params" do
      it "creates the user + 3 demo users and redirects to the home page" do
        password = "password"

        expect do
          post user_registration_path, params: {
            user: {
              first_name: "Liz",
              last_name: "Lemon",
              email: "liz@tgs.com",
              password:,
              password_confirmation: password,
            }
          }
        end.to change(User, :count).by(4)

        expect(response).to redirect_to root_path
      end
    end
  end
end
