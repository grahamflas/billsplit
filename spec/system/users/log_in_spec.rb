require "rails_helper"

RSpec.describe "User sign up", type: :system, js: true do
  context "for each successful log in" do
    scenario "creates a login event" do
      user = create(:user)

      sign_in_through_login_page(user)
      sign_out user

      sign_in_through_login_page(user)
      sign_out user

      sign_in_through_login_page(user)
      sign_out user

      expect(user.user_events.log_in.count).to eq(3)
    end
  end

  def sign_in_through_login_page(user)
    visit new_user_session_path

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password

    click_button "Log in"
  end
end
