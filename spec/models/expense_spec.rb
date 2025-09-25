require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe "validations" do
    subject { build(:expense) }
    it { should validate_presence_of(:reference) }
    it { should validate_numericality_of(:amount) }

    describe "#user_must_be_group_member" do
      it "is invalid if the user is not a member of the group" do
        group = create(:group)
        other_group = create(:group)

        user = create(
          :user,
          groups: [ group ],
        )

        other_user = create(
          :user,
          groups: [ other_group ],
        )

        valid_expense_1 = build(
          :expense,
          user:,
          group:,
        )
        valid_expense_2 = build(
          :expense,
          user: other_user,
          group: other_group,
        )

        invalid_expense_1 = build(
          :expense,
          user:,
        ).tap do |expense|
          expense.update(group: other_group)
        end

        invalid_expense_2 = build(
          :expense,
          user: other_user,
        ).tap do |expense|
          other_user.groups.delete(expense.group)
          other_user.groups << group
        end

        expect(valid_expense_1).to be_valid
        expect(valid_expense_2).to be_valid

        expect(invalid_expense_1).not_to be_valid
        expect(invalid_expense_2).not_to be_valid
      end
    end

    describe "#notify_other_group_users" do
      context "when it's a new expense" do
        it "creates an expense_added notification for group users other than the current_user" do
          group = create(:group)

          current_user = create(:user, groups: [ group ])
          other_user_1 = create(:user, groups: [ group ])
          other_user_2 = create(:user, groups: [ group ])

          expense = build(
            :expense,
            reference: "New expense",
            amount: 1,
            user: current_user,
            group:
          )

          expense.save

          expense.notify_other_group_users(current_user:)

          expect(
            Notification.find_by(
              user: other_user_1,
              source: expense,
              category: :expense_added,
            )
          ).to be_present

          expect(
            Notification.find_by(
              user: other_user_2,
              source: expense,
              category: :expense_added,
            )
          ).to be_present

          expect(
            Notification.find_by(
              user: current_user,
              source: expense,
              category: :expense_added,
            )
          ).not_to be_present
        end
      end

      context "when it's an existing expense" do
        it "creates an expense_updated notification for group users other than the current_user" do
          group = create(:group)

          current_user = create(:user, groups: [ group ])
          other_user_1 = create(:user, groups: [ group ])
          other_user_2 = create(:user, groups: [ group ])

          expense = create(
            :expense,
            reference: "New expense",
            amount: 1,
            user: other_user_1,
            group:
          )

          expense.update!(reference: "Updated expense")

          expense.notify_other_group_users(current_user:)

          expect(
            Notification.find_by(
              user: other_user_1,
              source: expense,
              category: :expense_updated,
            )
          ).to be_present

          expect(
            Notification.find_by(
              user: other_user_2,
              source: expense,
              category: :expense_updated,
            )
          ).to be_present

          expect(
            Notification.find_by(
              user: current_user,
              source: expense,
              category: :expense_updated,
            )
          ).not_to be_present
        end
      end
    end
  end
end
