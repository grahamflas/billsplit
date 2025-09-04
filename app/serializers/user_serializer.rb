class UserSerializer < ActiveModel::Serializer
  attributes(
    :email,
    :first_name,
    :id,
    :last_name,
  )
end
