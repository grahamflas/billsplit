class GroupSerializer < ApplicationSerializer
  include ActionView::Helpers::DateHelper

  attributes(:id, :name, :demo, :archived_on)

  attribute :readable_created_at,
    unless: :without_readable_created_at?

  attribute :readable_archived_on

  has_many :users
  has_many :expenses, unless: :without_expenses?

  def readable_created_at
    "#{time_ago_in_words(object.created_at)} ago"
  end

  def readable_archived_on
    if archived_on
      "#{time_ago_in_words(object.archived_on)} ago"
    end
  end

  def without_expenses?
    without?(:expenses)
  end

  def without_readable_created_at?
    without?(:readable_created_at)
  end

  def archived_on
    object.archived_on&.iso8601
  end
end
