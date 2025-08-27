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
        user_1.email => -19.33,
        user_2.email => -6.33,
        user_3.email => 25.67,
      })

      expect(
        result.values.sum.to_i
      ).to eq(0)
    end
  end
end
