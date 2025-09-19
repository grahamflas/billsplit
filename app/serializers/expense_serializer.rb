class ExpenseSerializer < ApplicationSerializer
  belongs_to :group

  attributes %i[
    amount
    created_at
    group_id
    id
    reference
    status
    user_id
  ]

  attribute :user

  def status
    Expense.statuses[object.status]
  end

  def user
    unless without?(:user)
      object.user.to_api
    end
  end
end
