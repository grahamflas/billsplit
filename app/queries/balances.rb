class Balances
  def initialize(group:)
    @group = group
  end

  def compute
    if @group
      {
        totalExpenses: total_expenses,
        userBalances: group_members.map do |member|
          {
            balance: (
              share_per_member - expenses_paid(member)
            ).round(2),
            firstName: member.first_name,
            lastName: member.last_name,
            userId: member.id,
          }
        end
      }
    end
  end

  private

  attr_reader :group

  def group_members
    @group_members ||= group.users
  end

  def share_per_member
    total_expenses.to_f / group_members.count
  end

  def total_expenses
    @total_expenses ||= group.expenses.sum(:amount)
  end

  def expenses_paid(member)
    member.
      expenses.
      where(group:).
      sum(:amount)
  end
end
