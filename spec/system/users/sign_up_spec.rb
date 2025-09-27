require "rails_helper"

RSpec.describe "User sign up", type: :system, js: true do
  context "when a user signs up and logs in for the first time" do
    scenario "it shows the 'About this demo' modal. Does not show the modal by default on subsequent logins/ page loads" do
      email = "user@mail.com"
      password = "password"

      visit new_user_registration_path

      fill_in "First name", with: "Liz"
      fill_in "Last name", with: "Lemon"
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Password confirmation", with: password

      click_button "Sign up"

      user = User.find_by(email:)

      expect(user.reload.has_seen_demo_modal).to be(false)

      within "#about-this-demo-modal" do
        expect(page).to have_content("About this demo")
        expect(page).to have_content("Hi, #{user.first_name}. Welcome to BillSplit!")

        find("button[aria-label='close modal']").click
      end

      expect(user.reload.has_seen_demo_modal).to be(true)

      visit group_path(user.groups.first)

      expect(page).not_to have_content("Hi, #{user.first_name}. Welcome to BillSplit!")

      find("[data-test='user-menu-button']").click

      click_link("Sign out")

      sign_in(user)

      visit root_path

      expect(page).not_to have_content("Hi, #{user.first_name}. Welcome to BillSplit!")
    end
  end
end


