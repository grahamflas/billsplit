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
  end
end
