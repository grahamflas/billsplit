class ExpenseSerializer < ActiveModel::Serializer
  attributes %i[
    id
    created_at
    user_id
    group_id
    amount
    reference
  ]

  attribute :user

  def user
    object.user.to_api
  end
end
