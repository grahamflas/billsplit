class ExpenseSerializer < ActiveModel::Serializer
  attributes %i[
    id
    user_id
    group_id
    amount
    reference
  ]
end
