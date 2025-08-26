require "rails_helper"

RSpec.describe "Navigation", type: :system, js: true do
  describe "Nav bar" do
    context "When a user is logged in" do
      it "shows the user's email, edit profile link, and a logout link" do
        user = create(:user)

        sign_in user

        visit root_path

        within "nav" do
          expect(page).to have_content("BillSp/it")

          expect(page).to have_content(user.email)
          expect(page).to have_link("Edit profile", href: edit_user_registration_path)
          expect(page).to have_link("Log out", href: destroy_user_session_path)

          expect(page).not_to have_link("Sign up", href: new_user_registration_path)
          expect(page).not_to have_link("Log in", href: new_user_session_path)
        end
      end
    end

    context "when a user is not logged in" do
      it "shows a link to sign up or log in" do
        user = create(:user)

        visit root_path

        within "nav" do
          expect(page).to have_content("BillSp/it")

          expect(page).to have_link("Sign up", href: new_user_registration_path)
          expect(page).to have_link("Log in", href: new_user_session_path)

          expect(page).not_to have_content(user.email)
          expect(page).not_to have_link("Edit Profile", href: edit_user_registration_path)
          expect(page).not_to have_link("Log out", href: destroy_user_session_path)
        end
      end
    end
  end
end
