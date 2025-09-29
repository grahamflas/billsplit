class ExpenseSerializer < ApplicationSerializer
  belongs_to :group

  attributes %i[
    amount
    group_id
    id
    reference
    status
    user_id
  ]

  attribute :user
  attribute :created_at

  def status
    Expense.statuses[object.status]
  end

  def user
    unless without?(:user)
      object.user.to_api.serializable_hash
    end
  end

  def created_at
    object.created_at.iso8601
  end
end
