class NotificationSerializer < ApplicationSerializer
  belongs_to :user

  attribute :source
  attribute :source_type

  def source
    object.source.to_api.serializable_hash
  end
end
