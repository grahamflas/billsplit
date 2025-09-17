class GroupSerializer < ApplicationSerializer
  include ActionView::Helpers::DateHelper

  attributes(:id, :name, )

  attribute :readable_created_at,
    unless: :without_readable_created_at?

  has_many :users
  has_many :expenses, unless: :without_expenses?

  def readable_created_at
    "#{time_ago_in_words(object.created_at)} ago"
  end

  def without_expenses?
    without?(:expenses)
  end

  def without_readable_created_at?
    without?(:readable_created_at)
  end
end
