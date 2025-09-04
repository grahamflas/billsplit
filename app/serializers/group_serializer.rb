class GroupSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes(:id, :name, :readable_created_at)

  has_many :users
  has_many :expenses

  def readable_created_at
    "#{time_ago_in_words(object.created_at)} ago"
  end
end
