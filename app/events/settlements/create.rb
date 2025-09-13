module Settlements
  class Create
    def initialize(group:, initiator:, balances:)
      @group = group
      @initiator = initiator
      @balances = balances
    end

    def process
      ApplicationRecord.transaction do
        settle_expenses
      end
    end

    private

    attr_reader :group, :initiator, :balances

    def settle_expenses
      group_open_expenses.each do |expense|
        expense.update!(
          status: :settled,
          settlement:,
        )
      end
    end

    def group_open_expenses
      group.expenses.open
    end

    def settlement
      @settlement ||= Settlement.create(
        group:,
        user: initiator,
        balances:
      )
    end
  end
end
