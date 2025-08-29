class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :users

  def users
    object.users.to_api
  end
end
