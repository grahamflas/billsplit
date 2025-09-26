class UserSerializer < ActiveModel::Serializer
  attributes(
    :email,
    :first_name,
    :id,
    :last_name,
  )

  attribute :full_name

  def full_name
    object.full_name
  end
end
