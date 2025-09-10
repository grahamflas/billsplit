require 'rails_helper'

RSpec.describe "Expenses", type: :request do
  describe "GET /show" do
    context "when not logged in" do
      it "redirects to login page" do
        group = create(:group)
        user = create(:user, groups: [ group ])
        expense = create(
          :expense,
          user:,
          group:
        )

        get expense_path(expense)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
    it "returns http success" do
      group = create(:group)
      user = create(:user, groups: [ group ])
      expense = create(
        :expense,
        user:,
        group:
      )

      sign_in user

      get expense_path(expense)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    context "when not logged in" do
      it "redirects to login page" do
        get new_expense_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    it "returns http success" do
      user = create(:user)

      sign_in user

      get new_expense_path
      expect(response).to have_http_status(:success)
    end
  end
end
