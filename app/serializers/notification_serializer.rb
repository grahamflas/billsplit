class NotificationSerializer < ApplicationSerializer
  belongs_to :user

  attributes(:id, :source_type, :category, :created_at)

  attribute :source
  attribute :link

  def source
    object.source.to_api.serializable_hash
  end

  def link
    case object.source
    when Expense, Settlement, Invitation
      group_path(object.source.group)
    when Group
      group_path(object.source)
    end
  end

  def created_at
    object.created_at.iso8601
  end
end
