require "rails_helper"

RSpec.describe Balances do
  context "when expenses are split evenly between all memebers of the group" do
    it "returns a hash showing which member owes what" do
      group = create(:group)

      user_1 = create(
        :user,
        groups: [ group ],
      )
      user_2 = create(
        :user,
        groups: [ group ],
      )
      user_3 = create(
        :user,
        groups: [ group ],
      )

      create(
        :expense,
        amount: 50,
        user: user_1,
        group:
      )
      create(
        :expense,
        amount: 37,
        user: user_2,
        group:
      )
      create(
        :expense,
        amount: 5,
        user: user_3,
        group:
      )

      result = Balances.new(group:).compute

      expect(result).to eq({
        totalExpenses: 92,
        userBalances: [
          {
            balance: -19.33,
            firstName: user_1.first_name,
            lastName: user_1.last_name,
            userId: user_1.id,
          },
          {
            balance: -6.33,
            firstName: user_2.first_name,
            lastName: user_2.last_name,
            userId: user_2.id,
          },
          {
            balance: 25.67,
            firstName: user_3.first_name,
            lastName: user_3.last_name,
            userId: user_3.id,
          },
        ]
      })

      expect(
        result[:userBalances].map do |user_balance_hash|
          user_balance_hash[:balance]
        end.sum.to_i
      ).to eq(0)
    end
  end
end
