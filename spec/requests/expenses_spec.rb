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

  describe "POST /create" do
    it "creates an expense and redirects to the expense.group show page" do
      group = create(:group)
      user = create(:user, groups: [ group ])

      sign_in user

      expect do
        post expenses_path, params: {
          expense: {
            reference: "My Expense",
            amount: 1,
            user_id: user.id,
            group_id: group.id,
          }
        }
      end.to change(Expense, :count).by(1)


      expect(response).to redirect_to(group_path(group))
    end
  end
end
