require "rails_helper"

RSpec.describe "Navigation", type: :system, js: true do
  describe "Nav bar" do
    context "When a user is logged in" do
      it "shows a My Groups link and a user dropdown with Edit Profile and Sign Out links" do
        user = create(:user)

        sign_in user

        visit root_path

        within "nav" do
          expect(page).to have_content("Bill÷Split")

          find("[data-test='my-groups-button']").click
        end

        within "[data-test='my-groups-dropdown']" do
          expect(page).to have_link("Active Groups", href: groups_path)
          expect(page).to have_link("Archived Groups", href: archived_groups_path)
        end

        within "nav" do
          find("[data-test='my-groups-button']").click

          find("[data-test='user-menu-button']").click
        end

        within "[data-test='user-menu-dropdown']" do
          expect(page).to have_link("Edit profile", href: edit_user_registration_path)
          expect(page).to have_link("Sign out", href: destroy_user_session_path)
        end
      end
    end

    context "when a user is not logged in" do
      it "shows a link to sign up or log in" do
        visit root_path

        within "nav" do
          expect(page).to have_content("Bill÷Split")

          expect(page).to have_link("Sign up", href: new_user_registration_path)
          expect(page).to have_link("Sign in", href: new_user_session_path)

          expect(page).not_to have_css("[data-test='user-menu-button']")
        end
      end
    end
  end
end
