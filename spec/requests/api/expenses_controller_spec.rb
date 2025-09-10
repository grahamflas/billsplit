require "rails_helper"

RSpec.describe Api::ExpensesController, type: :request do
  describe "POST /api/expenses" do
    it "creates an expense" do
      group = create(:group)
      user = create(:user, groups: [ group ])

      sign_in user

      new_expense_data = {
        amount: 500,
        reference: "Rent",
        user_id: user.id,
        group_id: group.id,
      }

      expect do
        post api_expenses_path, params: {
          expense: new_expense_data
        }
      end.to change(Expense, :count).by(1)
    end
  end

  describe "PUT /api/expenses/:id" do
    context "with valid params" do
      it "responds with OK status and updates the expense" do
        group = create(:group)
        user = create(:user, groups: [ group ])
        expense = create(
          :expense,
          amount: 1,
          user:,
          group:,
        )

        sign_in(user)

        put api_expense_path(expense.id), params: {
          expense: {
            id: expense.id,
            reference: "Updated Reference",
            amount: 100,
          }
        }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body)

        expect(expense.reload.reference).to eq("Updated Reference")
        expect(expense.amount).to eq(100)
      end
    end

    context "with invalid params" do
      it "returns error messages and 422 Unprocessable Content" do
        group = create(:group)
        user = create(:user, groups: [ group ])
        expense = create(
          :expense,
          amount: 1,
          user:,
          group:,
        )

        sign_in(user)


        put api_expense_path(expense.id), params: {
          expense: {
            id: expense.id,
            reference: "",
            amount: 100,
          }
        }

        expect(response.parsed_body[:errors]).to include("Reference can't be blank")
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    describe "updating other users' expenses" do
      context "when the expense belongs to other user" do
        context "when current_user is a member of expense.group" do
          it "responds with OK status and updates the expense" do
            group = create(:group)

            user_1 = create(:user, groups: [group])
            user_2 = create(:user, groups: [group])

            expense = create(
              :expense,
              amount: 50,
              user: user_2,
              group:,
            )

            sign_in(user_1)

            put api_expense_path(expense.id), params: {
              expense: {
                reference: "Updated by user_1",
                amount: 100,
              }
            }

            expect(response).to have_http_status(:ok)
            expect(expense.reload).to have_attributes(
              reference: "Updated by user_1",
              amount: 100
            )
          end
        end

        context "when current_user is NOT a member of expense.group" do
          it "responds with unauthorized and does not update the expense" do
            group_1 = create(:group)
            group_2 = create(:group)
            other_group = create(:group)

            user_1 = create(:user, groups: [group_1, group_2])
            user_2 = create(:user, groups: [group_1, group_2, other_group])

            expense = create(
              :expense,
              amount: 50,
              user: user_2,
              group: other_group,
            )

            original_attributes = expense.attributes

            sign_in(user_1)

            put api_expense_path(expense.id), params: {
              expense: {
                reference: "Updated by user_1",
                amount: 100,
              }
            }

            expect(expense.reload.attributes).to eq(original_attributes)
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end

    context "when the expense doesn't exist" do
      it "responses with unprocessable_content" do
        group = create(:group)
        user = create(:user, groups: [ group ])

        sign_in(user)

        put api_expense_path(999), params: {
          expense: {
            id: 999,
            reference: "",
            amount: 100,
          }
        }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
