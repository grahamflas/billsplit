module Settlements
  class Create
    def initialize(group:, initiator:, balances:, note: nil)
      @group = group
      @initiator = initiator
      @balances = balances
      @note = note
    end

    def process
      ApplicationRecord.transaction do
        settle_expenses
      end

      notify_users

      settlement
    rescue
      false
    end

    private

    attr_reader :group, :initiator, :balances, :note

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
        balances:,
        note:
      )
    end

    def notify_users
      group.users.each do |user|
        Notification.create!(
          user:,
          source: settlement,
          category: :settlement_created,
        )
      end
    end
  end
end
