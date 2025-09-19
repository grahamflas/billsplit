class NotificationSerializer < ApplicationSerializer
  belongs_to :user

  attributes(:id, :source_type, :category)

  attribute :source
  attribute :link

  def source
    object.source.to_api.serializable_hash
  end

  def link
    case object.source
    when Expense, Settlement
      group_path(object.source.group)
    end
  end
end
